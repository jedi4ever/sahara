module Sahara
  module Session
    class Virtualbox

      def initialize
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
        output = `#{@vboxcmd} showvminfo --machinereadable "#{instance_id}"`
        snapshotresult=output.scan(/SnapshotName.*=(.*)/).flatten
        snapshotresult.each do |result|
          clean=result.gsub(/\"/,'').chomp
          snapshotlist << clean
        end
        snapshotlist
      end

      def is_snapshot_mode_on?(machine)
        snapshots=self.list_snapshots(machine)
        return snapshots.include?(@sandboxname)
      end

      def off(machine)
        instance_id = machine.id
        `#{@vboxcmd} snapshot "#{instance_id}" delete "#{@sandboxname}" `
      end

      def on(machine)
        instance_id = machine.id
        `#{@vboxcmd} snapshot "#{instance_id}" take "#{@sandboxname}" --pause`
      end

      def commit(machine)
        instance_id = machine.id
        `#{@vboxcmd} snapshot "#{instance_id}" delete "#{@sandboxname}"`
        `#{@vboxcmd} snapshot "#{instance_id}" take "#{@sandboxname}" --pause`
      end

      def rollback(machine)
        instance_id = machine.id
        `#{@vboxcmd} controlvm "#{instance_id}" poweroff `
        sleep 2
        `#{@vboxcmd} snapshot "#{instance_id}" restore "#{@sandboxname}"`

        gui_boot = machine.provider_config.gui
        if gui_boot
          boot_mode = "gui"
        else
          boot_mode = "headless"
        end
        # restore boot mode
        `#{@vboxcmd} startvm --type #{boot_mode} "#{instance_id}" `
      end

      def is_vm_created?(machine)
        return !machine.id.nil?
      end

    end
  end
end
