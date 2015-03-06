# Supper (PRE-ALPHA)

Supper lets you store inventory levels for multiple products in Shopify Product [metafields](http://docs.shopify.com/api/metafield). Specify your Shopify API/Supplier FTP credentials in YAML, and let Supper handle the REST.

Supper is written in Ruby and uses [the official Shopify API gem](https://github.com/Shopify/shopify_api). It is a self-hosted app that you can set up to run automatically or manually, at your discretion.

Here is an overview of how it works:

![Sequence Diagram](https://raw.githubusercontent.com/acobster/supper/master/doc/images/sequence-diagram.png)

