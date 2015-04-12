#!/usr/bin/env ruby

require_relative 'load_path.rb'
require 'supper/summary'

summary = Supper::Summary.new
summary.summarize
