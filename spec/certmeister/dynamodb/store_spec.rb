require 'spec_helper'
require 'certmeister/test/memory_store_interface'

require 'certmeister/dynamodb/store'

describe Certmeister::DynamoDB::Store do

  TABLE_NAME = "CertmeisterCertificatesTest"

  class << self
    include Certmeister::Test::MemoryStoreInterface
  end

  subject do
    Certmeister::DynamoDB::Store.new(
      TABLE_NAME,
      {region: 'us-east-1', endpoint: ENV['DYNAMODB_ENDPOINT'] || 'http://localhost:8000' },
      {read_capacity_units: 10, write_capacity_units: 5}
    )
  end

  it_behaves_like_a_certmeister_store

  private

  def dynamodb_cleanup
    ddb_options = {region: 'us-east-1', endpoint: ENV['DYNAMODB_ENDPOINT'] || 'http://localhost:8000'}
    db = Aws::DynamoDB::Client.new(ddb_options)
    begin
      db.delete_table(table_name: TABLE_NAME)
      while db.describe_table(table_name: TABLE_NAME).table.table_status == "DELETING"
        $stderr.puts "Waiting for table #{TABLE_NAME} to be deleted"
        sleep 1
      end
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException
    end
  end

  before(:each) do
    dynamodb_cleanup
  end

  after(:each) do
    dynamodb_cleanup
  end

end

