require 'aws-sdk-core'
require 'time'

module Certmeister

  module DynamoDB

    class Store

      include Enumerable

      def initialize(table_name, options = {}, provision = {})
        @table_name = table_name
        @db = Aws::DynamoDB::Client.new(options)
        if !provision.empty?
          do_provisioning(provision)
        end
        @healthy = true
      end

      def store(cn, pem)
        @db.put_item(table_name: @table_name, item: {cn: cn, pem: pem})
      end

      def fetch(cn)
        if item = @db.get_item(table_name: @table_name, key: {cn: cn}).item
          item["pem"]
        end
      end

      def remove(cn)
        deleted = @db.delete_item(table_name: @table_name, key: {cn: cn}, return_values: "ALL_OLD").attributes
        !!deleted
      end

      def each
        @db.scan(table_name: @table_name).items.each do |item|
          yield item["cn"], item["pem"]
        end
      end

      def health_check
        @healthy
      end

      private

      def break!
        @healthy = false
      end

      def do_provisioning(provisioned_throughput)
        begin
          @db.describe_table(table_name: @table_name)
        rescue Aws::DynamoDB::Errors::ResourceNotFoundException
          @db.create_table(
            table_name: @table_name,
            attribute_definitions: [
              { 
                attribute_name: "cn",
                attribute_type: "S",
              }
            ],
            key_schema: [
              {
                attribute_name: "cn",
                key_type: "HASH",
              }
            ],
            provisioned_throughput: provisioned_throughput,
            # {
            #   read_capacity_units: 10,
            #   write_capacity_units: 5
            # }
          )
          while @db.describe_table(table_name: @table_name).table.table_status == "CREATING"
            $stderr.puts "Waiting for table #{@table_name} to be created"
            sleep 1
          end
        end
      end

    end

  end

end
