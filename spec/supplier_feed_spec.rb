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

  let(:feed) do
    feed = Supper::SupplierFeed.build config
  end

  let(:local_file) { 'tmp/local_file' }

  context 'when format is TXT' do
    let(:sku_field) { 0 }
    let(:quantity_field) { 3 }
    let(:delim) { "\t" }

    let(:config) {
      OpenStruct.new({
        inventory_format: format,
        ftp_host: ftp_host,
        ftp_user: ftp_user,
        ftp_password: ftp_password,
        remote_file: remote_file,
        sku_field: sku_field,
        quantity_field: quantity_field,
        delim: delim,
      })
    }

    it_behaves_like 'a SupplierFeed' do
      let(:format) { :txt }
      let(:klass) { Supper::TxtFeed }
      let(:raw_inventory) { raw_inventory_txt }
    end
  end
end
