# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nebius::CLI do
  let(:cli) { described_class.new }

  before do
    # Mock CLI availability check
    allow(Open3).to receive(:capture3).with('which', 'nebius')
                                      .and_return(['', '', double(success?: true)])
  end

  describe '#initialize' do
    it 'creates a CLI instance' do
      expect(cli).to be_a(Nebius::CLI)
    end

    it 'accepts profile parameter' do
      cli_with_profile = described_class.new(profile: 'test-profile')
      expect(cli_with_profile.profile).to eq('test-profile')
    end

    it 'accepts debug parameter' do
      cli_with_debug = described_class.new(debug: true)
      expect(cli_with_debug.debug).to be true
    end

    context 'when nebius CLI is not available' do
      before do
        allow(Open3).to receive(:capture3).with('which', 'nebius')
                                          .and_return(['', '', double(success?: false)])
      end

      it 'raises CLINotFoundError' do
        expect { described_class.new }.to raise_error(Nebius::CLINotFoundError)
      end
    end
  end

  describe '#execute' do
    let(:successful_status) { double(success?: true, exitstatus: 0) }
    let(:failed_status) { double(success?: false, exitstatus: 1) }

    context 'when command succeeds' do
      before do
        allow(Open3).to receive(:capture3)
          .with('nebius', '--format', 'json', 'version')
          .and_return(['{"version": "1.0.0"}', '', successful_status])
      end

      it 'returns parsed JSON by default' do
        result = cli.execute(['version'])
        expect(result).to eq({ 'version' => '1.0.0' })
      end

      it 'returns raw output when parse_json is false' do
        result = cli.execute(['version'], parse_json: false)
        expect(result).to eq('{"version": "1.0.0"}')
      end
    end

    context 'when command fails' do
      before do
        allow(Open3).to receive(:capture3)
          .with('nebius', '--format', 'json', 'invalid-command')
          .and_return(['', 'Command not found', failed_status])
      end

      it 'raises CommandError' do
        expect { cli.execute(['invalid-command']) }.to raise_error(Nebius::CommandError)
      end
    end

    context 'with profile' do
      let(:cli_with_profile) { described_class.new(profile: 'test-profile') }

      before do
        allow(Open3).to receive(:capture3)
          .with('nebius', '--profile', 'test-profile', '--format', 'json', 'version')
          .and_return(['{"version": "1.0.0"}', '', successful_status])
      end

      it 'includes profile in command' do
        result = cli_with_profile.execute(['version'])
        expect(result).to eq({ 'version' => '1.0.0' })
      end
    end

    context 'with different format' do
      before do
        allow(Open3).to receive(:capture3)
          .with('nebius', '--format', 'yaml', 'version')
          .and_return(['version: 1.0.0', '', successful_status])
      end

      it 'uses specified format' do
        result = cli.execute(['version'], format: 'yaml', parse_json: false)
        expect(result).to eq('version: 1.0.0')
      end
    end

    context 'with invalid JSON output' do
      before do
        allow(Open3).to receive(:capture3)
          .with('nebius', '--format', 'json', 'version')
          .and_return(['invalid json', '', successful_status])
      end

      it 'raises ParseError' do
        expect { cli.execute(['version']) }.to raise_error(Nebius::ParseError)
      end
    end
  end
end
