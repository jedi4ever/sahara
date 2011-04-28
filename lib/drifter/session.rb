require 'pp'

require 'drifter/shell'

module Drifter
  module Session
    
    def self.determine_vboxcmd
      return "VBoxManage"
    end

    def self.initialize
      @vagrant_env=Vagrant::Environment.new
      @vboxcmd=determine_vboxcmd
      @sandboxname="drifter-sandbox"
    end

    def self.status(boxname)
      self.initialize
      puts "Status: #{boxname}"
      puts is_vm_created?(boxname)
    end

    def self.on(boxname)
      puts "Entering sandbox state: #{boxname}"
      self.initialize
      instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"
      
      #Creating a snapshot
      execute("#{@vboxcmd} snapshot '#{instance_name}' take '#{@sandboxname}'")
    end

    def self.commit(boxname)
      puts "Committing sandbox changes: #{boxname}"
      
      self.initialize
      instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"
      
      #Discard snapshot so current state is the latest state
      execute("#{@vboxcmd} snapshot '#{instance_name}' delete '#{@sandboxname}'")

      #Now retake the snapshot
      execute("#{@vboxcmd} snapshot '#{instance_name}' take '#{@sandboxname}'")

    end

    def self.rollback(boxname)
      puts "Rollback sandbox: #{boxname}"
      self.initialize
      instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"

      puts "Poweringoff machine: #{boxname}"

      #Poweroff machine
      execute("#{@vboxcmd} controlvm '#{instance_name}' poweroff")

      #Rollback until snapshot
      execute("#{@vboxcmd} snapshot '#{instance_name}' restore '#{@sandboxname}'")

      #Startvm again
      execute("#{@vboxcmd} startvm '#{instance_name}' ")

      
    end

    def self.off(boxname)
      self.initialize
      instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"

    # We might wanna check for sandbox changes or not
    
    #Discard snapshot
    execute("#{@vboxcmd} snapshot '#{instance_name}' delete '#{@sandboxname}' ")
    
    end
      
    def self.execute(command)
      puts "#{command}"
      Drifter::Shell.execute("#{command}")
    end
    
    def self.is_vm_created?(boxname)
      return !@vagrant_env.vms[boxname.to_sym].vm.nil?
    end

    def self.on_selected_vms(boxname,&block)
      
    end
  end
end


#command="#{@vboxcmd} unregistervm  '#{boxname}' --delete"    
#puts command
#puts "Deleting vm #{boxname}"

#Exec and system stop the execution here
#Veewee::Shell.execute("#{command}")

