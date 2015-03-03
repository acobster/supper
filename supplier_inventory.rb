#!/usr/bin/env ruby

puts 'pretend error message! oh nooo' if File.exists? './foo'


# Just get every lib ever
# Dir.glob( 'lib/**/*.rb' ).each do |file|
#   require Dir.pwd+'/'+file
# end


