# frozen_string_literal: true

module Nebius
  module Resources
    # VPC (Virtual Private Cloud) resource management
    class VPC
      def initialize(cli)
        @cli = cli
      end

      # Access network operations
      #
      # @return [Nebius::Resources::VPC::Network] Network operations
      def network
        @network ||= Network.new(@cli)
      end

      # Access subnet operations
      #
      # @return [Nebius::Resources::VPC::Subnet] Subnet operations
      def subnet
        @subnet ||= Subnet.new(@cli)
      end

      # Network management
      class Network
        def initialize(cli)
          @cli = cli
        end

        # List all networks
        #
        # @return [Array<Hash>] List of networks
        def list
          @cli.execute(['vpc', 'network', 'list'])
        end

        # Get network details
        #
        # @param name [String] Network name
        # @return [Hash] Network details
        def get(name:)
          @cli.execute(['vpc', 'network', 'get', name])
        end

        # Create a new network
        #
        # @param name [String] Network name
        # @param cidr [String] CIDR block
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, cidr: nil, **options)
          command = ['vpc', 'network', 'create', name]
          command += ['--cidr', cidr] if cidr
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a network
        #
        # @param name [String] Network name
        # @return [Hash] Deletion result
        def delete(name:)
          @cli.execute(['vpc', 'network', 'delete', name])
        end
      end

      # Subnet management
      class Subnet
        def initialize(cli)
          @cli = cli
        end

        # List all subnets
        #
        # @return [Array<Hash>] List of subnets
        def list
          @cli.execute(['vpc', 'subnet', 'list'])
        end

        # Get subnet details
        #
        # @param name [String] Subnet name
        # @return [Hash] Subnet details
        def get(name:)
          @cli.execute(['vpc', 'subnet', 'get', name])
        end

        # Create a new subnet
        #
        # @param name [String] Subnet name
        # @param network [String] Parent network name
        # @param cidr [String] CIDR block
        # @param zone [String] Availability zone
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, network:, cidr:, zone: nil, **options)
          command = ['vpc', 'subnet', 'create', name]
          command += ['--network', network]
          command += ['--cidr', cidr]
          command += ['--zone', zone] if zone
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a subnet
        #
        # @param name [String] Subnet name
        # @return [Hash] Deletion result
        def delete(name:)
          @cli.execute(['vpc', 'subnet', 'delete', name])
        end
      end
    end
  end
end
