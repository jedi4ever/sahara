require 'pp'

module Sahara
  module Session
    class Command 

      def initialize(app, env)
        @app = app
        @env = env
        @vboxcmd=determine_vboxcmd
        @sandboxname="sahara-sandbox"
      end
  
      def determine_vboxcmd
        if windows?
          # On Windows, we use the VBOX_INSTALL_PATH environmental
          if ENV.has_key?("VBOX_INSTALL_PATH")
            # The path usually ends with a \ but we make sure here
            path = File.join(ENV["VBOX_INSTALL_PATH"], "VBoxManage.exe")
            return "\"#{path}\""
          end
        else
          # for other platforms assume it is on the PATH
          return "VBoxManage"
        end
      end
  
      def windows?
        %W[mingw mswin].each do |text|
          return true if RbConfig::CONFIG["host_os"].downcase.include?(text)
        end
        false
      end
  
      def list_snapshots(machine)
        snapshotlist=Array.new
        instance_id = machine.id
        output = `#{@vboxcmd} showvminfo --machinereadable \"#{instance_id}\"`
        snapshotresult=output.scan(/SnapshotName.*=(.*)/).flatten
        snapshotresult.each do |result|
          clean=result.gsub(/\"/,'').chomp
          snapshotlist << clean
        end
        snapshotlist
      end
  
      def status(machine)
        if !self.is_vm_created?(machine) then
          puts "vm is not created"
          return
        end
        if self.is_snapshot_mode_on?(machine) then
          puts "Sandbox mode is on"
        else
          puts "Sandbox mode is off"
        end
      end
  
      def is_snapshot_mode_on?(machine)
        snapshots=self.list_snapshots(machine)
        return snapshots.include?(@sandboxname)
      end
  
      def off(machine)
        if !self.is_vm_created?(machine) then
          puts "vm is not created"
          return
        end
        if self.is_snapshot_mode_on?(machine) then
          instance_id = machine.id
          `#{@vboxcmd} snapshot \"#{instance_id}\" delete \"#{@sandboxname}\" `
        else
          puts "NOT sandbox mode now"
        end
      end
  
      def on(machine)
        if !self.is_vm_created?(machine) then
          puts "vm is not created"
          return
        end
        if !self.is_snapshot_mode_on?(machine) then
          instance_id = machine.id
          `#{@vboxcmd} snapshot \"#{instance_id}\" take \"#{@sandboxname}\" --pause`
        else
          puts "already sandbox mode"
        end
      end
  
      def commit(machine)
        if !self.is_vm_created?(machine) then
          puts "vm is not created"
          return
        end
        if self.is_snapshot_mode_on?(machine) then
          instance_id = machine.id
          `#{@vboxcmd} snapshot \"#{instance_id}\" delete \"#{@sandboxname}\"`
          `#{@vboxcmd} snapshot \"#{instance_id}\" take \"#{@sandboxname}\" --pause`
        else
          puts "NOT sandbox mode now"
        end
      end
  
      def rollback(machine)
        if !self.is_vm_created?(machine) then
          puts "vm is not created"
          return
        end
        if !self.is_snapshot_mode_on?(machine) then
          puts "NOT sandbox mode now"
          return
        end
  
        instance_id = machine.id
        `#{@vboxcmd} controlvm \"#{instance_id}\" poweroff `
        sleep 2
        `#{@vboxcmd} snapshot \"#{instance_id}\" restore \"#{@sandboxname}\"`
  
        gui_boot = machine.provider_config.gui
        if gui_boot 
          boot_mode = "gui"
        else
          boot_mode = "headless"
        end
        # restore boot mode
        `#{@vboxcmd} startvm --type #{boot_mode} \"#{instance_id}\" `
      end
  
      def is_vm_created?(machine)
        return !machine.id.nil?
      end
  
    end
  end
end
