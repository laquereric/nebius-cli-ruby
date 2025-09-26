# frozen_string_literal: true

module Nebius
  module Resources
    # Storage resource management
    class Storage
      def initialize(cli)
        @cli = cli
      end

      # Access bucket operations
      #
      # @return [Nebius::Resources::Storage::Bucket] Bucket operations
      def bucket
        @bucket ||= Bucket.new(@cli)
      end

      # Bucket management
      class Bucket
        def initialize(cli)
          @cli = cli
        end

        # List all buckets
        #
        # @return [Array<Hash>] List of buckets
        def list
          @cli.execute(['storage', 'bucket', 'list'])
        end

        # Get bucket details
        #
        # @param name [String] Bucket name
        # @return [Hash] Bucket details
        def get(name:)
          @cli.execute(['storage', 'bucket', 'get', name])
        end

        # Create a new bucket
        #
        # @param name [String] Bucket name
        # @param region [String] Bucket region
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, region: nil, **options)
          command = ['storage', 'bucket', 'create', name]
          command += ['--region', region] if region
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a bucket
        #
        # @param name [String] Bucket name
        # @param force [Boolean] Force deletion
        # @return [Hash] Deletion result
        def delete(name:, force: false)
          command = ['storage', 'bucket', 'delete', name]
          command += ['--force'] if force
          
          @cli.execute(command)
        end

        # Update bucket configuration
        #
        # @param name [String] Bucket name
        # @param options [Hash] Configuration options
        # @return [Hash] Update result
        def update(name:, **options)
          command = ['storage', 'bucket', 'update', name]
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end
      end
    end
  end
end
