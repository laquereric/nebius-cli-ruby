# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nebius::Client do
  let(:client) { described_class.new }

  before do
    # Mock CLI availability check
    allow(Open3).to receive(:capture3).with('which', 'nebius')
                                      .and_return(['', '', double(success?: true)])
  end

  describe '#initialize' do
    it 'creates a client instance' do
      expect(client).to be_a(Nebius::Client)
    end

    it 'accepts profile parameter' do
      client_with_profile = described_class.new(profile: 'test-profile')
      expect(client_with_profile.profile).to eq('test-profile')
    end

    it 'accepts debug parameter' do
      client_with_debug = described_class.new(debug: true)
      expect(client_with_debug.debug).to be true
    end
  end

  describe '#compute' do
    it 'returns a Compute resource instance' do
      expect(client.compute).to be_a(Nebius::Resources::Compute)
    end

    it 'memoizes the compute instance' do
      expect(client.compute).to be(client.compute)
    end
  end

  describe '#storage' do
    it 'returns a Storage resource instance' do
      expect(client.storage).to be_a(Nebius::Resources::Storage)
    end

    it 'memoizes the storage instance' do
      expect(client.storage).to be(client.storage)
    end
  end

  describe '#iam' do
    it 'returns an IAM resource instance' do
      expect(client.iam).to be_a(Nebius::Resources::IAM)
    end

    it 'memoizes the iam instance' do
      expect(client.iam).to be(client.iam)
    end
  end

  describe '#vpc' do
    it 'returns a VPC resource instance' do
      expect(client.vpc).to be_a(Nebius::Resources::VPC)
    end

    it 'memoizes the vpc instance' do
      expect(client.vpc).to be(client.vpc)
    end
  end

  describe '#mk8s' do
    it 'returns an MK8s resource instance' do
      expect(client.mk8s).to be_a(Nebius::Resources::MK8s)
    end

    it 'memoizes the mk8s instance' do
      expect(client.mk8s).to be(client.mk8s)
    end
  end

  describe '#version' do
    before do
      allow(Open3).to receive(:capture3)
        .with('nebius', '--format', 'json', 'version')
        .and_return(['nebius version 1.0.0', '', double(success?: true, exitstatus: 0)])
    end

    it 'returns the CLI version' do
      expect(client.version).to eq('nebius version 1.0.0')
    end
  end

  describe '#profiles' do
    before do
      profile_output = <<~OUTPUT
        default
        my-profile [default]
        another-profile
      OUTPUT

      allow(Open3).to receive(:capture3)
        .with('nebius', '--format', 'json', 'profile', 'list')
        .and_return([profile_output, '', double(success?: true, exitstatus: 0)])
    end

    it 'returns parsed profile list' do
      profiles = client.profiles
      expect(profiles).to eq([
        { name: 'default', default: false },
        { name: 'my-profile', default: true },
        { name: 'another-profile', default: false }
      ])
    end
  end

  describe '#create_profile' do
    before do
      allow(Open3).to receive(:capture3)
        .with('nebius', '--format', 'json', 'profile', 'create', '--parent-id', 'project-123')
        .and_return(['Profile created successfully', '', double(success?: true, exitstatus: 0)])
    end

    it 'creates a new profile' do
      result = client.create_profile(parent_id: 'project-123')
      expect(result).to eq('Profile created successfully')
    end

    context 'with profile name' do
      before do
        allow(Open3).to receive(:capture3)
          .with('nebius', '--format', 'json', 'profile', 'create', '--parent-id', 'project-123', '--name', 'test-profile')
          .and_return(['Profile created successfully', '', double(success?: true, exitstatus: 0)])
      end

      it 'includes the profile name in the command' do
        result = client.create_profile(parent_id: 'project-123', name: 'test-profile')
        expect(result).to eq('Profile created successfully')
      end
    end
  end
end
