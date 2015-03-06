require 'spec_helper'

RSpec.describe Supper::Config do
  let(:config_yaml) do
    <<-_YAML_
---
suppliers:
  bobs:
    ftp_user: bobs_client
    ftp_password: password
    shop_tagged_with: Bob
  janes:
    ftp_user: janes_client
    ftp_password: asdf1234
    shop_tagged_with: Jane
    _YAML_
  end

  it 'returns an object with an internal RecursiveOpenStruct' do
    expect( File ).to receive( :read ).and_return( config_yaml )
    config = Supper::Config.new
    expect( config.suppliers ).to be_a RecursiveOpenStruct

    expect( config.suppliers.bobs ).to be_a RecursiveOpenStruct
    expect( config.suppliers.bobs.ftp_user ).to eq 'bobs_client'
    expect( config.suppliers.bobs.ftp_password ).to eq 'password'
    expect( config.suppliers.bobs.shop_tagged_with ).to eq 'Bob'

    expect( config.suppliers.janes ).to be_a RecursiveOpenStruct
    expect( config.suppliers.janes.ftp_user ).to eq 'janes_client'
    expect( config.suppliers.janes.ftp_password ).to eq 'asdf1234'
    expect( config.suppliers.janes.shop_tagged_with ).to eq 'Jane'
  end
end