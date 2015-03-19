require 'spec_helper'
require 'supper/config'

RSpec.describe Supper::Config do
  include_context 'config'

  describe '#load_from_file' do
    context 'when file exists at relative path' do
      it 'returns a Config object'
    end

    context 'when file exists at absolute path' do
      it 'returns a Config object'
    end
  end

  describe '#initialize' do
    it 'returns an object with an internal Hash' do
      config = Supper::Config.new config_yaml
      suppliers = config['suppliers']
      expect( suppliers ).to be_an Array

      expect( suppliers[0] ).to be_a Hash
      expect( suppliers[0]['ftp_user'] ).to eq 'bobs_client'
      expect( suppliers[0]['ftp_password'] ).to eq 'password'
      expect( suppliers[0]['shopify_tag'] ).to eq 'Bob'

      expect( suppliers[1] ).to be_a Hash
      expect( suppliers[1]['ftp_user'] ).to eq 'janes_client'
      expect( suppliers[1]['ftp_password'] ).to eq 'asdf1234'
      expect( suppliers[1]['shopify_tag'] ).to eq 'Jane'
    end
  end

  describe '#validate!' do
    subject { config.validate }

    context 'when structure is valid' do
      let(:config) { valid_config }
      # it { should be true }
    end
  end
end
