require 'spec_helper'
require 'supper/supplier_feed'
require 'supper/csv_feed'
require 'supper/txt_feed'
require 'ostruct'

RSpec::describe Supper::SupplierFeed do
  include_context 'suppliers'

  let(:ftp_host) { 'host.domain.com' }
  let(:ftp_user) { 'user' }
  let(:ftp_password) { 'pass' }
  let(:remote_file) { 'remote_file' }
  let(:sku_field) { 'SKU' }
  let(:quantity_field) { 'quantity' }

  let(:config) {
    OpenStruct.new({
      inventory_format: format,
      ftp_host: ftp_host,
      ftp_user: ftp_user,
      ftp_password: ftp_password,
      remote_file: remote_file,
      sku_field: sku_field,
      quantity_field: quantity_field,
    })
  }

  let(:local_file) { 'tmp/local_file' }

  let(:feed) do
    feed = Supper::SupplierFeed.build config
  end

  context 'when format is CSV' do
    it_behaves_like 'a SupplierFeed' do
      let(:format) { :csv }
      let(:klass) { Supper::CsvFeed }
      let(:raw_inventory) { raw_inventory_csv }
    end
  end

  context 'when format is TXT' do
    it_behaves_like 'a SupplierFeed' do
      let(:format) { :txt }
      let(:klass) { Supper::TxtFeed }
      let(:raw_inventory) { raw_inventory_txt }
    end
  end
end
