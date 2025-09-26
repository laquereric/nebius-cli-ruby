# frozen_string_literal: true

module Nebius
  # Base error class for Nebius CLI errors
  class Error < StandardError
    attr_reader :command, :exit_code, :stderr

    def initialize(message, command: nil, exit_code: nil, stderr: nil)
      super(message)
      @command = command
      @exit_code = exit_code
      @stderr = stderr
    end

    def to_s
      msg = super
      msg += " (command: #{command})" if command
      msg += " (exit code: #{exit_code})" if exit_code
      msg += " (stderr: #{stderr})" if stderr && !stderr.empty?
      msg
    end
  end

  # Error raised when the Nebius CLI is not found
  class CLINotFoundError < Error; end

  # Error raised when a command execution fails
  class CommandError < Error; end

  # Error raised when JSON parsing fails
  class ParseError < Error; end
end
