require 'spec_helper'
require 'supper/config'

RSpec.describe Supper::Config do
  include_context 'config'

  describe '#load_from_file' do
    let!(:stub_file) do
      expect( File ).to receive(:exists?).
        once.
        with('config.yml').
        and_return(file_exists)
      expect( File ).to receive(:read).once.and_return('FAKE YAML')
    end

    subject { Supper::Config.load_from_file 'config.yml' }

    context 'when file exists at relative path' do
      let!(:file_exists) { true }
      it { should be_a Supper::Config }
    end

    context 'when file exists at absolute path' do
      let!(:file_exists) { false }
      it { should be_a Supper::Config }
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
end
