#!/usr/bin/ruby
#
#Filename: ADMIN_scrub_list.rb
#Description: Scrub Vicidial Call List from dnc database
#License: Angelito Manasala avmanansala@gmail.com Licese GPL v2

require ('rubygems')
require ('parseconfig')
require ('active_record')
require ('active_support')
require 'db_conn.rb'

ActiveRecord::Base.establish_connection(
:adapter => 'mysql',
:host => @mysql_server_ip,
:database => @mysql_database,
:username => @mysql_user,
:password => @mysql_pass
)


class Vicidial_lists < ActiveRecord::Base
  set_table_name "vicidial_lists"
end
class Vicidial_list < ActiveRecord::Base
  set_table_name "vicidial_list"
end

puts 'Listing List ID'

Vicidial_lists.all().each do |lists| 
  puts "List ID: #{lists.list_id}\n"
end


puts "Done...\n"
