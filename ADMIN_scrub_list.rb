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


list_id = ARGV[0]

puts "List id to scrub: #{list_id}\n"

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
class Vicidial_dnc < ActiveRecord::Base
  set_table_name "vicidial_dnc"
end
class Vicidial_dnc2 < ActiveRecord::Base
  set_table_name "vicidial_dnc2"
end

#iterate through selected lists
Vicidial_list.all(:conditions => "list_id = '#{list_id}'").each do |list|
  
  puts "Checking #{list.phone_number}..."
  
  #check is record exist on dnc and dnc2 table
  Vicidial_dnc2.all(:all, :conditions => "phone_number = '#{list.phone_number}'").each do |list| 
    puts "#{list.phone_number} DNC matches!..."
  end
     
  
end


puts "Done...\n"
