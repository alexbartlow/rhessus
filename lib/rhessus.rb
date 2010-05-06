require File.join 'connections', 'scan'
require 'optparse'
require 'fastercsv'
require 'scan_runner'
module Rhessus
  VERSION = '0.1.0'
  class << self
    # returns the information necessary to start a scan
    # nessus path, -T nbe -q host name password
    def scanner
      return @scanner if @scanner
      exe = @nessus || `which nessus`.chomp
      exe = '/opt/nessus/bin/nessus ' if exe == ""
      options = " -T nbe -q "
      login   = " #{@host || 'localhost'} #{@port || 1241} #{@username} #{@password} "
      @scanner = exe + options + login
    end
    
    def parse_results(res)
      puts "Attempting Parse"
      res.split("\n").collect {|x| 
        r = x.split("|")
      }.select{|x| x[0] == "results"}.
        collect do |result|
          {:ip => result[2],
            :port => result[3],
            :plugin_id => result[4],
            :severity  => (case result[5] 
            when "Security Note"
              0
            when "Security Warning"
              1
            when "Security Hole"
              2
            end),
            :details => result[6]
          }
        end
    end
    
    # Parse the options
    def init
      @host = 'localhost'
      @username = 'admin'
      @password = 'password'
      OptionParser.new do |opts|
        opts.on('-h', '--host [HOST]', 
          "The host running the scanner (default localhost)") do |h|
            @host = h
          end
        opts.on('-u', '--username USER',
          "The username on the nessus scanner") do |u|
            @username = u
          end
        opts.on('-p', '--password PASS',
          "The password for the scanner") do |p|
            @password = p
          end
        opts.on('-o', '--port [PORT]',
          "The port of the nessus scanner (default 1241)") do |p|
            @port = p
          end
        opts.on('-s', '--site SITE', "Site to push uploads (incl. http://)") do |s|
            ::Rhessus::Scan.site = s
          end
        opts.on('-n', '--nessus NESSUS', "Nessus executable (unneeded if in path)") do |n|
          @nessus = n
        end
        opts.on('-H', '--help', "Show this message") do |h|
          puts opts
          exit
        end
      end.parse!
    end
    
    # If can locate the average 5 minute load of the system
    # and that load is below .6 or the user-defined threshold, returns true
    def system_load_ok?
      true
    end
  end
end
