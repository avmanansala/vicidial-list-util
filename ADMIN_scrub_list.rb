#!/usr/bin/ruby
#
#Filename: ADMIN_scrub_list.rb
#Description: Scrub Vicidial Call List from dnc database
#License: Angelito Manasala avmanansala@gmail.com Licese GPL v2

require ('rubygems')
require ('parseconfig')
require ('active_record')
require ('active_support')
 
#Parse astguiclient configuration file.
my_config = ParseConfig.new('/etc/astguiclient.conf')
mysql_server_ip = my_config.get_value('VARserver_ip').gsub('>','').strip
mysql_server = my_config.get_value('VARDB_server').gsub('>','').strip
mysql_database = my_config.get_value('VARDB_database').gsub('>','').strip
mysql_user = my_config.get_value('VARDB_user').gsub('>','').strip
mysql_pass = my_config.get_value('VARDB_pass').gsub('>','').strip
mysql_port = my_config.get_value('VARDB_port').gsub('>','').strip
#end::Parse config

ActiveRecord::Base.establish_connection(
:adapter => 'mysql',
:host => mysql_server_ip,
:database => mysql_database,
:username => mysql_user,
:password => mysql_pass
)


class Vicidial_lists < ActiveRecord::Base
  set_table_name "vicidial_lists"
end
class Vicidial_list < ActiveRecord::Base
  set_table_name "vicidial_list"
end

puts 'Listing List ID'

Vicidial_lists.all().each do |lists| 
  puts lists.list_id
end


puts "Done...\n"
