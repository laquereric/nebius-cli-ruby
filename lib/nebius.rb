# frozen_string_literal: true

require_relative 'nebius/version'
require_relative 'nebius/error'
require_relative 'nebius/cli'
require_relative 'nebius/client'

# Main module for the Nebius CLI Ruby wrapper
module Nebius
  class << self
    # Create a new client instance
    #
    # @param profile [String] The Nebius CLI profile to use
    # @param debug [Boolean] Enable debug mode
    # @return [Nebius::Client] A new client instance
    def new(profile: nil, debug: false)
      Client.new(profile: profile, debug: debug)
    end

    # Get the gem version
    #
    # @return [String] The gem version
    def version
      VERSION
    end
  end
end
