# frozen_string_literal: true

module Nebius
  module Resources
    # Compute resource management
    class Compute
      def initialize(cli)
        @cli = cli
      end

      # Access instance operations
      #
      # @return [Nebius::Resources::Compute::Instance] Instance operations
      def instance
        @instance ||= Instance.new(@cli)
      end

      # Access disk operations
      #
      # @return [Nebius::Resources::Compute::Disk] Disk operations
      def disk
        @disk ||= Disk.new(@cli)
      end

      # Access image operations
      #
      # @return [Nebius::Resources::Compute::Image] Image operations
      def image
        @image ||= Image.new(@cli)
      end

      # Instance management
      class Instance
        def initialize(cli)
          @cli = cli
        end

        # List all instances
        #
        # @return [Array<Hash>] List of instances
        def list
          @cli.execute(['compute', 'instance', 'list'])
        end

        # Get instance details
        #
        # @param name [String] Instance name
        # @return [Hash] Instance details
        def get(name:)
          @cli.execute(['compute', 'instance', 'get', name])
        end

        # Create a new instance
        #
        # @param name [String] Instance name
        # @param zone [String] Availability zone
        # @param machine_type [String] Machine type
        # @param image [String] Boot image
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, zone:, machine_type:, image:, **options)
          command = ['compute', 'instance', 'create', name]
          command += ['--zone', zone]
          command += ['--machine-type', machine_type]
          command += ['--image', image]
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete an instance
        #
        # @param name [String] Instance name
        # @return [Hash] Deletion result
        def delete(name:)
          @cli.execute(['compute', 'instance', 'delete', name])
        end

        # Start an instance
        #
        # @param name [String] Instance name
        # @return [Hash] Operation result
        def start(name:)
          @cli.execute(['compute', 'instance', 'start', name])
        end

        # Stop an instance
        #
        # @param name [String] Instance name
        # @return [Hash] Operation result
        def stop(name:)
          @cli.execute(['compute', 'instance', 'stop', name])
        end

        # Restart an instance
        #
        # @param name [String] Instance name
        # @return [Hash] Operation result
        def restart(name:)
          @cli.execute(['compute', 'instance', 'restart', name])
        end
      end

      # Disk management
      class Disk
        def initialize(cli)
          @cli = cli
        end

        # List all disks
        #
        # @return [Array<Hash>] List of disks
        def list
          @cli.execute(['compute', 'disk', 'list'])
        end

        # Get disk details
        #
        # @param name [String] Disk name
        # @return [Hash] Disk details
        def get(name:)
          @cli.execute(['compute', 'disk', 'get', name])
        end

        # Create a new disk
        #
        # @param name [String] Disk name
        # @param size [String] Disk size (e.g., '10GB')
        # @param type [String] Disk type
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, size:, type: nil, **options)
          command = ['compute', 'disk', 'create', name]
          command += ['--size', size]
          command += ['--type', type] if type
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a disk
        #
        # @param name [String] Disk name
        # @return [Hash] Deletion result
        def delete(name:)
          @cli.execute(['compute', 'disk', 'delete', name])
        end
      end

      # Image management
      class Image
        def initialize(cli)
          @cli = cli
        end

        # List all images
        #
        # @return [Array<Hash>] List of images
        def list
          @cli.execute(['compute', 'image', 'list'])
        end

        # Get image details
        #
        # @param name [String] Image name
        # @return [Hash] Image details
        def get(name:)
          @cli.execute(['compute', 'image', 'get', name])
        end
      end
    end
  end
end
