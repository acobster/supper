# Supper (Beta)

Supper automatically updates *inventory policy* settings for individual Shopify product variants based on inventory levels of your suppliers. This is really useful for use-cases like "drop shipping," where you have in-store stock that may run out, but you also have suppliers who may be able to ship direct to your customers, as *their* inventory levels allow.

Specify your credentials in YAML, tell it which collection of products to keep in sync, and let Supper handle the REST.

Supper is written in Ruby and uses [the official Shopify API gem](https://github.com/Shopify/shopify_api) to talk to your Shopify store via the REST API. It is a self-hosted app that you can set up to run automatically or manually, at your discretion.

## How it works:

* You clone Supper onto your server/laptop/Raspberry Pi/whatever running Ruby
* You configure and run it (see below)
* Supper requests products in the "feedable" collection (you can set an arbitrary `collection_id` in your config file).
* For each supplier you configure, Supper:
  * requests inventory via FTP
  * matches each feedable product *variant* to a line in the supplier inventory file by SKU
  * determines the availability of each product variant, and updates Shopify's `inventory_policy` field for that variant as necessary

## Requirements 

* Ruby (tested with 1.9.3)
* Bundler

## Installation

```
$ git clone git@bitbucket.org:acobster/supper.git
$ cd supper
$ bundle install
```

After that, just set up your Shopify and Supplier FTP credentials (see below for configuration) and run it:

```
$ ruby supper.rb my-custom-config.yml # tell supper where the config file is. this defaults to "config.yml"
```

## Configuration

See `sample-config.yml` for a detailed configuration example. Here are the highlights:

For each supplier, specify:

* FTP host/port/user/password
* the path to the inventory file
* which Shopify tag corresponds to this supplier (to differentiate it from other "feedable" products)
* the format in which to expect the inventory file (supports CSV and delimited TXT files)
* SKU Field: the key or index holding the SKU field for a given row in the inventory file
* Quantity Field: the key or index holding the Quantity field for a given row in the inventory file
* An arbitrary field delimiter such as `\t`, for delimiting product fields in text files

For your Shopify store, specify:

* Shopify API Key/Password and your shop name
* The collection ID for feedable products
* The collection type to use for finding feedable products: `smart` maps to `ShopifyAPI::SmartCollection` (corresponding to [automated collections](https://help.shopify.com/manual/products/collections/automated-shopify-collection)); anything else tells Supper to use `ShopifyAPI::CustomCollection` (corresponding to [manual collections](https://help.shopify.com/manual/products/collections/manual-shopify-collection)).
* You may also optionally specify an `exclusions` block, which tells Supper to filter out product variants by vertain criteria. Currently the only supported criterion is `tag`, with which you can specify an *array* of Shopify Tag names to exclude. See the sample config for an example of this.

## Setting up the database/web server

There's no database! Everything is stored in the config file. 

Nope, no web server either. Just configure and run it.

## Gotchas

* To stay withing API usage limits, it's recommended that you set the `shopify.seconds_between_calls` to `0.5`. This is in the config for end-to-end testing reasons. I'm sure there's a more elegant approach here but hey I made this thing on a budget for a single site...PR? :)
* Only private Shopify apps are currently supported. Ditto?
* Logging is pretty janky right now. It writes to `.json` files straight from the `Supper::Base` class instead of doing proper dependency injection. Meh.

