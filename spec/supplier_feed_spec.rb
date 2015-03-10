require 'spec_helper'
require 'supper/supplier_feed'
require 'supper/csv_feed'
require 'supper/txt_feed'

RSpec::describe Supper::SupplierFeed do
  let(:ftp_host) { 'host.domain.com' }
  let(:ftp_user) { 'user' }
  let(:ftp_pass) { 'pass' }
  let(:remote_file) { 'remote_file' }
  let(:local_file) { 'tmp/local_file' }

  let(:feed) do
    Supper::SupplierFeed.new ftp_host, ftp_user, ftp_pass, remote_file
  end

  describe 'class methods' do
    describe '#build' do
      let(:info) { double('info') }

      subject { Supper::SupplierFeed::build info }

      before do
        expect( info ).to receive( :inventory_format ).once.and_return(format)
        expect( info ).to receive( :ftp_host ).once
        expect( info ).to receive( :ftp_user ).once
        expect( info ).to receive( :ftp_password ).once
        expect( info ).to receive( :ftp_inventory_file ).once
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
      expect( ftp ).to receive( :login ).once.with( ftp_user, ftp_pass )
      expect( ftp ).to receive( :gettextfile ).once.with( remote_file, local_file )

      feed.copy_inventory_file ftp
    end
  end

  describe '#read' do
    it 'returns a hash'
  end
end