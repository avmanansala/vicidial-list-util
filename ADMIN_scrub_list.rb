#!/usr/bin/ruby
#
#Filename: ADMIN_scrub_list.rb
#Description: Scrub Vicidial Call List from dnc database
#License: Angelito Manasala avmanansala@gmail.com Licese GPL v2


puts "Filename: ADMIN_scrub_list.rb"
puts "License: Angelito Manasala avmanansala@gmail.com Licese GPL v2"
puts 

require ('rubygems')
require ('parseconfig')
require ('active_record')
require ('active_support')
require 'db_conn.rb'


def sample_usage
  puts "Sample usage:"
  puts "/usr/share/astguiclient/ADMIN_scrub_list.rb 1234 "
  puts "(where 1234 is the list_id of the call list you will be scrubbing)"
end
def update_status_to_dnc(lead_id_to_update)
  puts "Updating status to DNC..."
  Vicidial_list.update(lead_id_to_update, :status => 'DNC')
  puts "Lead id  #{lead_id_to_update} status updated to DNC"
end
def commify(number)
    c = { :value => "", :length => 0 }
    r = number.to_s.reverse.split("").inject(c) do |t, e|  
      iv, il = t[:value], t[:length]
      iv += ',' if il % 3 == 0 && il != 0    
      { :value => iv + e, :length => il + 1 }
    end
    r[:value].reverse!
end


if ARGV.length == 0
   sample_usage()
   Process.exit
end

list_id = ARGV[0]

puts "Attention:"
puts "this script will mark/set the list status to 'DNC' if record matches to vicidial_dnc and vicidial_dnc2 tables"
print "Press y to continue: " 
STDOUT.flush
action = STDIN.gets

if action.strip != "y"  
  puts "Aborting..."
  Process.exit
end

ActiveRecord::Base.establish_connection(
:adapter => 'mysql',
:host => @mysql_server_ip,
:database => @mysql_database,
:username => @mysql_user,
:password => @mysql_pass
)


class Vicidial_lists < ActiveRecord::Base
  set_table_name "vicidial_lists"
  #set_primary_key "lead_id"
end
class Vicidial_list < ActiveRecord::Base
  set_table_name "vicidial_list"
  set_primary_key "lead_id"
end
class Vicidial_dnc < ActiveRecord::Base
  set_table_name "vicidial_dnc"
end
class Vicidial_dnc2 < ActiveRecord::Base
  set_table_name "vicidial_dnc2"
end

list_count = commify(Vicidial_list.count(:limit => 100, :conditions => "list_id = '#{list_id}'"))
dnc_match_count = 0

puts "Cleaning list #{list_id} with #{list_count} record(s)\n"

#iterate through selected lists
Vicidial_list.all(:conditions => "list_id = '#{list_id}' AND status NOT IN('DNC','DNCL') ").each do |list|
  
  puts "Checking #{list.phone_number} on vicidial_dnc2 table..."
  lead_id = list.lead_id
  #check is record exist on  vicidial_dnc2 table
  #puts "Comparing list #{list_id} to vicidial_dnc2 table"
  if Vicidial_dnc2.count(:conditions => "phone_number = '#{list.phone_number}'") > 0
    puts "Oops! #{list.phone_number} DNC matches"
    puts "Currrent list status is #{list.status}"
    update_status_to_dnc(lead_id)
    dnc_match_count += 1
  end
end

Vicidial_list.all(:conditions => "list_id = '#{list_id}' AND status NOT IN('DNC','DNCL') ").each do |list|
  
  puts "Checking #{list.phone_number} on vicidial_dnc table..."
  
 #check is record exist on  vicidial_dnc table
  if Vicidial_dnc.count(:conditions => "phone_number = '#{list.phone_number}'") > 0
     puts "Oops! #{list.phone_number} DNC matches!"
     puts "Currrent list status is #{list.status}"
     update_status_to_dnc(lead_id)
     dnc_match_count += 1
   end
  
end

puts "total list count: #{list_count}"
puts "total dnc count: #{dnc_match_count}"
puts "Done...\n"





