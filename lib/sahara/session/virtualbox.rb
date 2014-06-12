module Sahara
  module Session
    class Virtualbox

      def initialize(machine)
        @machine=machine
        @instance_id = @machine.id
        @vboxcmd=determine_vboxcmd
        @sandboxname="sahara-sandbox"
      end

      def determine_vboxcmd
        if windows?
          # On Windows, we use the VBOX_INSTALL_PATH and VBOX_MSI_INSTALL_PATH environmental
          if ENV.has_key?("VBOX_INSTALL_PATH") || ENV.has_key?("VBOX_MSI_INSTALL_PATH")
            # The path usually ends with a \ but we make sure here
            path = ENV["VBOX_INSTALL_PATH"] || ENV["VBOX_MSI_INSTALL_PATH"]
            path = File.join(path, "VBoxManage.exe")
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

      def list_snapshots
        snapshotlist=Array.new
        output = `#{@vboxcmd} showvminfo --machinereadable "#{@instance_id}"`
        snapshotresult=output.scan(/SnapshotName.*=(.*)/).flatten
        snapshotresult.each do |result|
          clean=result.gsub(/\"/,'').chomp
          snapshotlist << clean
        end
        snapshotlist
      end

      def is_snapshot_mode_on?
        snapshots=self.list_snapshots
        return snapshots.include?(@sandboxname)
      end

      def off
        `#{@vboxcmd} snapshot "#{@instance_id}" delete "#{@sandboxname}" `
      end

      def on
        `#{@vboxcmd} snapshot "#{@instance_id}" take "#{@sandboxname}" --pause`
      end

      def commit
        `#{@vboxcmd} snapshot "#{@instance_id}" delete "#{@sandboxname}"`
        `#{@vboxcmd} snapshot "#{@instance_id}" take "#{@sandboxname}" --pause`
      end

      def rollback
        `#{@vboxcmd} controlvm "#{@instance_id}" poweroff `
        sleep 2
        `#{@vboxcmd} snapshot "#{@instance_id}" restore "#{@sandboxname}"`

        gui_boot = @machine.provider_config.gui
        if gui_boot
          boot_mode = "gui"
        else
          boot_mode = "headless"
        end
        # restore boot mode
        `#{@vboxcmd} startvm --type #{boot_mode} "#{@instance_id}" `
      end

      def is_vm_created?
        return !@machine.id.nil?
      end

    end
  end
end
