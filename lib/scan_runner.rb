require 'tempfile'
module Rhessus
  # Encapulates scan targetting and running
  class ScanRunner < Scan
    self.element_name = "scan"
    # waits until it can safely get a fork, then initiates a new scan at its target
    # The forked process attempts to notify the central authority upon being killed that
    # the scan was a failure
    def fire!
      # safely get a fork and fire the scan
      return nil unless should_fire?
      tryagain = true
      pid = nil
      @path = lock(self.targets)
      while tryagain
        begin
          if pid = fork(&self)
            tryagain = false
          end
        rescue Errno::EWOULDBLOCK
          sleep 5
          tryagain = true
        end
      end
      Process.detach(pid)
    end
    
    # The procedure that should be executed when the scan actually runs, 
    # including signal handling
    def to_proc
      if should_fire?
        Proc.new do
	  puts "Attempting to fire scan... #{scan_string}"
	  puts "#{::Rhessus.scanner}"
          begin
            Signal.trap("KILL") do 
              self.failure
              exit
            end
            Signal.trap("TERM") do 
              self.failure
              exit
            end
          checkin(system(::Rhessus.scanner + scan_string) && File.read(@results))
          rescue
            self.failure
            exit
          end
        end
      else
        Proc.new { nil }
      end
    end
    
    # Creates a tempfile containing the scans
    def lock(targets)
      @results = Tempfile.new("rhessus-scan-#{self.id}-results").path
      (Tempfile.new("rhessus-scan-#{self.id}-targets").tap do |x|
        x.puts targets
        x.flush
      end).path
    end
    
    # the second half of the scanner's data (after host, login, password)
    def scan_string
      " #{@path} #{@results}"
    end
  end
end
