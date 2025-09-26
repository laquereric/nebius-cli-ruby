# frozen_string_literal: true

require 'open3'
require 'json'

module Nebius
  # Handles execution of Nebius CLI commands
  class CLI
    attr_reader :profile, :debug

    def initialize(profile: nil, debug: false)
      @profile = profile
      @debug = debug
      check_cli_availability!
    end

    # Execute a Nebius CLI command
    #
    # @param command [Array<String>] The command parts to execute
    # @param format [String] The output format (json, yaml, table, text)
    # @param parse_json [Boolean] Whether to parse JSON output
    # @return [Hash, String] Parsed JSON or raw output
    def execute(command, format: 'json', parse_json: true)
      full_command = build_command(command, format: format)
      
      puts "Executing: #{full_command.join(' ')}" if debug
      
      stdout, stderr, status = Open3.capture3(*full_command)
      
      unless status.success?
        raise CommandError.new(
          "Command failed: #{stderr}",
          command: full_command.join(' '),
          exit_code: status.exitstatus,
          stderr: stderr
        )
      end

      if parse_json && format == 'json'
        parse_json_output(stdout)
      else
        stdout
      end
    end

    private

    def check_cli_availability!
      _, _, status = Open3.capture3('which', 'nebius')
      
      unless status.success?
        raise CLINotFoundError, 'Nebius CLI not found. Please install it first.'
      end
    end

    def build_command(command, format: 'json')
      cmd = ['nebius']
      cmd += ['--profile', profile] if profile
      cmd += ['--format', format] if format
      cmd += ['--debug'] if debug
      cmd += command
      cmd
    end

    def parse_json_output(output)
      return {} if output.strip.empty?
      
      JSON.parse(output)
    rescue JSON::ParserError => e
      raise ParseError, "Failed to parse JSON output: #{e.message}"
    end
  end
end
