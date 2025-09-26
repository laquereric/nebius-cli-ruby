# frozen_string_literal: true

Given('I have the Nebius CLI installed') do
  # This is mocked in the env.rb file
end

When('I create a new Nebius client') do
  @client = Nebius.new
end

When('I create a new Nebius client with profile {string}') do |profile|
  @client = Nebius.new(profile: profile)
end

When('I create a new Nebius client with debug mode enabled') do
  @client = Nebius.new(debug: true)
end

Then('the client should be successfully initialized') do
  expect(@client).to be_a(Nebius::Client)
end

Then('the client should be initialized with the specified profile') do
  expect(@client.profile).to eq('my-profile')
end

Then('the client should be initialized with debug mode enabled') do
  expect(@client.debug).to be true
end
