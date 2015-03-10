require 'spec_helper'
require 'supper/supplier_feed'
require 'supper/csv_feed'
require 'supper/txt_feed'

RSpec::describe Supper::SupplierFeed do
  include_context 'suppliers'

  let(:ftp_host) { 'host.domain.com' }
  let(:ftp_user) { 'user' }
  let(:ftp_password) { 'pass' }
  let(:remote_file) { 'remote_file' }
  let(:sku_field) { 'SKU' }
  let(:quantity_field) { 'quantity' }

  let(:local_file) { 'tmp/local_file' }

  let(:feed) do
    feed = Supper::SupplierFeed.new
    feed.ftp_host = ftp_host
    feed.ftp_user = ftp_user
    feed.ftp_password = ftp_password
    feed.remote_file = remote_file
    feed.sku_field = sku_field
    feed.quantity_field = quantity_field

    feed
  end

  describe 'class methods' do
    describe '#build' do
      let(:info) { double('info') }

      subject { Supper::SupplierFeed::build info }

      before do
        expect( info ).to receive( :inventory_format ).once.and_return(format)
        expect( info ).to receive( :ftp_host ).once.and_return( ftp_host )
        expect( info ).to receive( :ftp_user ).once.and_return( ftp_user )
        expect( info ).to receive( :ftp_password ).once.and_return( ftp_password )
        expect( info ).to receive( :remote_file ).once.and_return( remote_file )
        expect( info ).to receive( :sku_field ).once.and_return( sku_field )
        expect( info ).to receive( :quantity_field ).once.and_return( quantity_field )
      end

      context 'when format is CSV' do
        let(:format) { :csv }

        it 'returns a CsvFeed' do
          expect( subject ).to be_a Supper::CsvFeed
        end
      end

      context 'when format is TXT' do
        let(:format) { :txt }

        it 'returns a TxtFeed' do
          expect( subject ).to be_a Supper::TxtFeed
        end
      end
    end
  end

  describe '#copy_inventory_file' do
    it 'copies the file locally' do
      # control what the local file is called
      expect( Dir::Tmpname ).to receive( :make_tmpname ).once.
        with( 'tmp/', '' ).and_return( local_file )

      ftp = double('ftp')
      expect( ftp ).to receive( :connect ).once.with( ftp_host )
      expect( ftp ).to receive( :passive= ).once.with( true )
      expect( ftp ).to receive( :login ).once.with( ftp_user, ftp_password )
      expect( ftp ).to receive( :gettextfile ).once.with( remote_file, local_file )

      feed.copy_inventory_file ftp
    end
  end

  describe '#read' do
    # it 'returns a hash' do
    #   expect( File ).to receive(:read).once.and_return( text_inventory_txt )

    #   supplier_inventory = feed.read
    #   expect( supplier_inventory ).to be_a Hash

    #   text_inventory_hash.each do |sku, quantity|
    #     expect( supplier_inventory[sku] ).to eq quantity
    #   end
    # end
  end
end
