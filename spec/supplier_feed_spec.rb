require 'spec_helper'
require 'supper/supplier_feed'
require 'supper/csv_feed'
require 'supper/txt_feed'
require 'ostruct'

RSpec::describe Supper::SupplierFeed do
  include_context 'suppliers'

  let(:ftp_host) { 'host.domain.com' }
  let(:ftp_port) { 212121 }
  let(:ftp_user) { 'user' }
  let(:ftp_password) { 'pass' }
  let(:remote_file) { 'remote_file' }

  let(:feed) do
    feed = Supper::SupplierFeed.build config
  end

  let(:local_file) { 'tmp/local_file' }

  context 'when format is TXT' do
    let(:sku_field) { 0 }
    let(:quantity_field) { 3 }
    let(:delim) { "\t" }

    let(:config) {
      {
        'inventory_format' => format,
        'ftp_host' => ftp_host,
        'ftp_port' => ftp_port,
        'ftp_user' => ftp_user,
        'ftp_password' => ftp_password,
        'ftp_inventory_file' => remote_file,
        'sku_field' => sku_field,
        'quantity_field' => quantity_field,
        'delim' => delim,
      }
    }

    it_behaves_like 'a SupplierFeed' do
      let(:format) { :txt }
      let(:klass) { Supper::TxtFeed }
      let(:raw_inventory) { raw_inventory_txt }

      describe '#encode_and_strip_invalid_chars' do
        subject { feed.encode_and_strip_invalid_chars invalid_line }

        it 'returns raw text with bad chars stripped' do
          expect( subject ).to eq valid_line
        end

        context 'when line is already valid'
      end
    end
  end
end
