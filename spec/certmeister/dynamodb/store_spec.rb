require 'spec_helper'
require 'certmeister/test/memory_store_interface'

require 'certmeister/dynamodb/store'

describe Certmeister::DynamoDB::Store do

  TABLE_NAME = "CertmeisterCertificatesTest"

  class << self
    include Certmeister::Test::MemoryStoreInterface
  end

  let(:ddb_options) do
    {endpoint: 'http://127.0.0.1:8000', credentials: Aws::Credentials.new('key_id', 'secret_key')}
  end

  subject do
    Certmeister::DynamoDB::Store.new(
      TABLE_NAME,
      ddb_options,
      {read_capacity_units: 10, write_capacity_units: 5}
    )
  end

  it_behaves_like_a_certmeister_store

  private

  def dynamodb_cleanup
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

