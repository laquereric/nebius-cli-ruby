# frozen_string_literal: true

require_relative 'resources/compute'
require_relative 'resources/storage'
require_relative 'resources/iam'
require_relative 'resources/vpc'
require_relative 'resources/mk8s'

module Nebius
  # Main client class for interacting with Nebius services
  class Client
    attr_reader :cli, :profile, :debug

    def initialize(profile: nil, debug: false)
      @profile = profile
      @debug = debug
      @cli = CLI.new(profile: profile, debug: debug)
    end

    # Access compute resources
    #
    # @return [Nebius::Resources::Compute] Compute resource interface
    def compute
      @compute ||= Resources::Compute.new(cli)
    end

    # Access storage resources
    #
    # @return [Nebius::Resources::Storage] Storage resource interface
    def storage
      @storage ||= Resources::Storage.new(cli)
    end

    # Access IAM resources
    #
    # @return [Nebius::Resources::IAM] IAM resource interface
    def iam
      @iam ||= Resources::IAM.new(cli)
    end

    # Access VPC resources
    #
    # @return [Nebius::Resources::VPC] VPC resource interface
    def vpc
      @vpc ||= Resources::VPC.new(cli)
    end

    # Access Managed Kubernetes resources
    #
    # @return [Nebius::Resources::MK8s] MK8s resource interface
    def mk8s
      @mk8s ||= Resources::MK8s.new(cli)
    end

    # Get CLI version
    #
    # @return [String] The Nebius CLI version
    def version
      cli.execute(['version'], parse_json: false).strip
    end

    # List available profiles
    #
    # @return [Array<Hash>] List of profiles
    def profiles
      output = cli.execute(['profile', 'list'], parse_json: false)
      parse_profile_list(output)
    end

    # Create a new profile
    #
    # @param parent_id [String] The parent project ID
    # @param name [String] The profile name
    # @return [Hash] Profile creation result
    def create_profile(parent_id:, name: nil)
      command = ['profile', 'create', '--parent-id', parent_id]
      command += ['--name', name] if name
      
      cli.execute(command, parse_json: false)
    end

    private

    def parse_profile_list(output)
      profiles = []
      output.each_line do |line|
        line = line.strip
        next if line.empty?
        
        if line.include?('[default]')
          name = line.gsub('[default]', '').strip
          profiles << { name: name, default: true }
        else
          profiles << { name: line, default: false }
        end
      end
      profiles
    end
  end
end
