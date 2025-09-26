# frozen_string_literal: true

module Nebius
  module Resources
    # MK8s (Managed Kubernetes) resource management
    class MK8s
      def initialize(cli)
        @cli = cli
      end

      # Access cluster operations
      #
      # @return [Nebius::Resources::MK8s::Cluster] Cluster operations
      def cluster
        @cluster ||= Cluster.new(@cli)
      end

      # Access node group operations
      #
      # @return [Nebius::Resources::MK8s::NodeGroup] Node group operations
      def node_group
        @node_group ||= NodeGroup.new(@cli)
      end

      # Cluster management
      class Cluster
        def initialize(cli)
          @cli = cli
        end

        # List all clusters
        #
        # @return [Array<Hash>] List of clusters
        def list
          @cli.execute(['mk8s', 'cluster', 'list'])
        end

        # Get cluster details
        #
        # @param name [String] Cluster name
        # @return [Hash] Cluster details
        def get(name:)
          @cli.execute(['mk8s', 'cluster', 'get', name])
        end

        # Create a new cluster
        #
        # @param name [String] Cluster name
        # @param version [String] Kubernetes version
        # @param network [String] VPC network
        # @param subnet [String] VPC subnet
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, version:, network:, subnet:, **options)
          command = ['mk8s', 'cluster', 'create', name]
          command += ['--version', version]
          command += ['--network', network]
          command += ['--subnet', subnet]
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a cluster
        #
        # @param name [String] Cluster name
        # @return [Hash] Deletion result
        def delete(name:)
          @cli.execute(['mk8s', 'cluster', 'delete', name])
        end

        # Get cluster credentials
        #
        # @param name [String] Cluster name
        # @return [String] Kubeconfig content
        def get_credentials(name:)
          @cli.execute(['mk8s', 'cluster', 'get-credentials', name], parse_json: false)
        end
      end

      # Node group management
      class NodeGroup
        def initialize(cli)
          @cli = cli
        end

        # List all node groups
        #
        # @param cluster [String] Cluster name
        # @return [Array<Hash>] List of node groups
        def list(cluster:)
          @cli.execute(['mk8s', 'node-group', 'list', '--cluster', cluster])
        end

        # Get node group details
        #
        # @param name [String] Node group name
        # @param cluster [String] Cluster name
        # @return [Hash] Node group details
        def get(name:, cluster:)
          @cli.execute(['mk8s', 'node-group', 'get', name, '--cluster', cluster])
        end

        # Create a new node group
        #
        # @param name [String] Node group name
        # @param cluster [String] Cluster name
        # @param machine_type [String] Machine type for nodes
        # @param min_size [Integer] Minimum number of nodes
        # @param max_size [Integer] Maximum number of nodes
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, cluster:, machine_type:, min_size: 1, max_size: 3, **options)
          command = ['mk8s', 'node-group', 'create', name]
          command += ['--cluster', cluster]
          command += ['--machine-type', machine_type]
          command += ['--min-size', min_size.to_s]
          command += ['--max-size', max_size.to_s]
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a node group
        #
        # @param name [String] Node group name
        # @param cluster [String] Cluster name
        # @return [Hash] Deletion result
        def delete(name:, cluster:)
          @cli.execute(['mk8s', 'node-group', 'delete', name, '--cluster', cluster])
        end
      end
    end
  end
end
