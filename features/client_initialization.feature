Feature: Client Initialization
  As a developer using the Nebius Ruby gem
  I want to initialize a client
  So that I can interact with Nebius services

  Scenario: Initialize client without parameters
    Given I have the Nebius CLI installed
    When I create a new Nebius client
    Then the client should be successfully initialized

  Scenario: Initialize client with profile
    Given I have the Nebius CLI installed
    When I create a new Nebius client with profile "my-profile"
    Then the client should be initialized with the specified profile

  Scenario: Initialize client with debug mode
    Given I have the Nebius CLI installed
    When I create a new Nebius client with debug mode enabled
    Then the client should be initialized with debug mode enabled
