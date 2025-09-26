# frozen_string_literal: true

module Nebius
  module Resources
    # IAM (Identity and Access Management) resource management
    class IAM
      def initialize(cli)
        @cli = cli
      end

      # Access user operations
      #
      # @return [Nebius::Resources::IAM::User] User operations
      def user
        @user ||= User.new(@cli)
      end

      # Access service account operations
      #
      # @return [Nebius::Resources::IAM::ServiceAccount] Service account operations
      def service_account
        @service_account ||= ServiceAccount.new(@cli)
      end

      # Access role operations
      #
      # @return [Nebius::Resources::IAM::Role] Role operations
      def role
        @role ||= Role.new(@cli)
      end

      # User management
      class User
        def initialize(cli)
          @cli = cli
        end

        # List all users
        #
        # @return [Array<Hash>] List of users
        def list
          @cli.execute(['iam', 'user', 'list'])
        end

        # Get user details
        #
        # @param id [String] User ID
        # @return [Hash] User details
        def get(id:)
          @cli.execute(['iam', 'user', 'get', id])
        end
      end

      # Service account management
      class ServiceAccount
        def initialize(cli)
          @cli = cli
        end

        # List all service accounts
        #
        # @return [Array<Hash>] List of service accounts
        def list
          @cli.execute(['iam', 'service-account', 'list'])
        end

        # Get service account details
        #
        # @param id [String] Service account ID
        # @return [Hash] Service account details
        def get(id:)
          @cli.execute(['iam', 'service-account', 'get', id])
        end

        # Create a new service account
        #
        # @param name [String] Service account name
        # @param description [String] Service account description
        # @param options [Hash] Additional options
        # @return [Hash] Creation result
        def create(name:, description: nil, **options)
          command = ['iam', 'service-account', 'create', name]
          command += ['--description', description] if description
          
          options.each do |key, value|
            command += ["--#{key.to_s.tr('_', '-')}", value.to_s]
          end

          @cli.execute(command)
        end

        # Delete a service account
        #
        # @param id [String] Service account ID
        # @return [Hash] Deletion result
        def delete(id:)
          @cli.execute(['iam', 'service-account', 'delete', id])
        end
      end

      # Role management
      class Role
        def initialize(cli)
          @cli = cli
        end

        # List all roles
        #
        # @return [Array<Hash>] List of roles
        def list
          @cli.execute(['iam', 'role', 'list'])
        end

        # Get role details
        #
        # @param id [String] Role ID
        # @return [Hash] Role details
        def get(id:)
          @cli.execute(['iam', 'role', 'get', id])
        end
      end
    end
  end
end
