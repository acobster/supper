# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rsspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separetly)
#  * 'just' rspec: 'rspec'
guard :rspec, cmd: 'rspec', notification: true do
  watch('spec/spec_helper.rb') { |m| 'spec' }
  watch(%r{^spec/.+_spec\.rb$}) { |m| m[0] }
  watch(%r{^lib/supper/([a-z_]+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/supper/(csv|txt)_feed.rb$}) { |m| 'spec/supplier_feed_spec.rb' }
  watch(%r{^spec/shared/(suppliers_context|supplier_feed_examples).rb$}) { |m| 'spec/supplier_feed_spec.rb' }
  watch('spec/shared/config_context.rb') { 'spec/config_spec.rb' }
end

