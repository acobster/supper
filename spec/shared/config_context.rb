require 'supper/config'

RSpec.shared_context 'config' do
  let(:config_yaml) do
    yaml = <<-_YAML_
---
suppliers:
  - ftp_host: ftp.bobs.com
    ftp_port: 212121
    ftp_user: bobs_client
    ftp_password: password
    ftp_inventory_file: "Inventory/InventoryWeb.txt"
    shopify_tag: Bob
    inventory_format: txt
    delim: "\t"
    sku_field: 0 # SKU is in the first column of each line of text
    quantity_field: 3 # Quantity is the fourth column
  - ftp_host: ftp.janes.com
    # port defaults to 21
    ftp_user: janes_client
    ftp_password: asdf1234
    ftp_inventory_file: "janes_inventory.csv"
    shopify_tag: Jane
    inventory_format: csv
shopify:
  api_key: "YOUR_API_KEY_HERE"
  api_password: "YOUR_API_PASSWORD_HERE"
  shop_name: "YOUR_API_SHOP_NAME_HERE"
  collection_id: 1234567890
  collection_type: smart
  app_type: private
admin_email: email@example.com
    _YAML_
  end

  let(:valid_config) { Supper::Config.new config_yaml }
end