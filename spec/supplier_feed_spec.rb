require 'spec_helper'

RSpec::describe Supper::SupplierFeed do
  describe 'class methods' do
    describe '#build' do
      let(:info) { double('info') }

      subject { Supper::SupplierFeed::build info }

      before do
        expect( info ).to receive( :inventory_format ).once.and_return(format)
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
end