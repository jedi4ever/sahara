require 'pp'

require 'sahara/shell'

module Sahara
  module Session

    def self.determine_vboxcmd
      return "VBoxManage"
    end

    def self.initialize
      @vagrant_env=Vagrant::Environment.new
      @vboxcmd=determine_vboxcmd
      @sandboxname="sahara-sandbox"
    end

    def self.status(selection)
      self.initialize

      on_selected_vms(selection) do |boxname|
        if is_snapshot_mode_on?(boxname)
          puts "[#{boxname}] - snapshot mode is on"
        else
          puts "[#{boxname}] - snapshot mode is off"
        end
      end

    end

    def self.on(selection)
      self.initialize

      on_selected_vms(selection) do |boxname|
        if is_snapshot_mode_on?(boxname)
          puts "[#{boxname}] - snapshot mode is already on"
        else
          instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"

          #Creating a snapshot
          puts "[#{boxname}] - Enabling sandbox"

          execute("#{@vboxcmd} snapshot '#{instance_name}' take '#{@sandboxname}'")
        end

      end
    end

    def self.commit(selection)

      self.initialize
      on_selected_vms(selection) do |boxname|


        if !is_snapshot_mode_on?(boxname)
          puts "[#{boxname}] - this requires that sandbox mode is on."
        else
          instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"

          #Discard snapshot so current state is the latest state
          puts "[#{boxname}] - unwinding sandbox"
          execute("#{@vboxcmd} snapshot '#{instance_name}' delete '#{@sandboxname}'")

          #Now retake the snapshot
          puts "[#{boxname}] - fastforwarding sandbox"

          execute("#{@vboxcmd} snapshot '#{instance_name}' take '#{@sandboxname}'")
          
        end

      end

    end

    def self.rollback(selection)
      self.initialize

      on_selected_vms(selection) do |boxname|

        if !is_snapshot_mode_on?(boxname)
          puts "[#{boxname}] - this requires that sandbox mode is on."
        else
          instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"

          puts "[#{boxname}] - powering off machine"

          #Poweroff machine
          execute("#{@vboxcmd} controlvm '#{instance_name}' poweroff")

          puts "[#{boxname}] - roll back machine"

          #Rollback until snapshot
          execute("#{@vboxcmd} snapshot '#{instance_name}' restore '#{@sandboxname}'")

          puts "[#{boxname}] - starting the machine again"

          #Startvm again
          execute("#{@vboxcmd} startvm --type headless '#{instance_name}' ")
          
        end

      end


    end

    def self.off(selection)
      self.initialize

      on_selected_vms(selection) do |boxname|


        instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"

        if !is_snapshot_mode_on?(boxname)
          puts "[#{boxname}] - this requires that sandbox mode is on."
        else
          puts "[#{boxname}] - switching sandbox off"

          # We might wanna check for sandbox changes or not

          #Discard snapshot
          execute("#{@vboxcmd} snapshot '#{instance_name}' delete '#{@sandboxname}' ")

        end

      end
    end

    def self.execute(command)
      #puts "#{command}"
      output=Sahara::Shell.execute("#{command}")
      return output
    end

    def self.is_vm_created?(boxname)
      return !@vagrant_env.vms[boxname.to_sym].vm.nil?
    end

    def self.list_snapshots(boxname)

      instance_name="#{@vagrant_env.vms[boxname.to_sym].vm.name}"
      snapshotlist=Array.new
      snapshotresult=execute("#{@vboxcmd} showvminfo --machinereadable '#{instance_name}' |grep ^SnapshotName| cut -d '=' -f 2")
      snapshotresult.each do |result|
        clean=result.gsub(/\"/,'').chomp
        snapshotlist << clean
      end
      return snapshotlist
    end

    def self.is_snapshot_mode_on?(boxname)
      snapshots=list_snapshots(boxname)
      return snapshots.include?(@sandboxname)
    end

    def self.on_selected_vms(selection,&block)
      
      if selection.nil?
        #puts "no selection was done"
        @vagrant_env.vms.each do |name,vm|
          #puts "Processing #{name}"
          if @vagrant_env.multivm?
            if name.to_s!="default"
            if is_vm_created?(name)
              yield name
            else
              puts "[#{name}] - machine needs to be upped first"
            end
          end
          else
            if is_vm_created?(name)
              yield name
            else
              puts "[#{name}] - machine needs to be upped first"
            end
          end
        end
      else
        if is_vm_created?(selection)
          yield selection
        else
          puts "[#{selection}] - machine needs to be upped first"
        end
      end
    end
  end
end


#command="#{@vboxcmd} unregistervm  '#{boxname}' --delete"    
#puts command
#puts "Deleting vm #{boxname}"

#Exec and system stop the execution here
#Veewee::Shell.execute("#{command}")

