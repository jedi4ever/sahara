module Sahara
  module Session
    class VMWare

      def initialize(machine)
        @machine=machine
        @vmx_path=@machine.provider.driver.vmx_path
        @vmwarecmd=@machine.provider.driver.instance_variable_get(:@vmrun_path).to_s.gsub(" ", "\\ ")
        @sandboxname="sahara-sandbox"
        if @machine.provider.driver.class.to_s != "HashiCorp::VagrantVMwarefusion::Driver::Fusion"
          raise Sahara::Errors::ProviderNotSupported
        end
      end

      def list_snapshots
        output = `#{@vmwarecmd} listSnapshots "#{@vmx_path}"`
        output.rstrip.split(/\r?\n/).map {|line| line.chomp }
      end

      def is_snapshot_mode_on?
        snapshots=self.list_snapshots
        return snapshots.include?(@sandboxname)
      end

      def off
        `#{@vmwarecmd} -T ws deleteSnapshot "#{@vmx_path}" "#{@sandboxname}"`
      end

      def on
        `#{@vmwarecmd} -T ws snapshot "#{@vmx_path}" "#{@sandboxname}"`
      end

      def commit
        `#{@vmwarecmd} -T ws deleteSnapshot "#{@vmx_path}" "#{@sandboxname}"`
        `#{@vmwarecmd} -T ws snapshot "#{@vmx_path}" "#{@sandboxname}"`
      end

      def rollback
        `#{@vmwarecmd} -T ws revertToSnapshot "#{@vmx_path}" "#{@sandboxname}" `
        sleep 2

        gui_boot = @machine.provider_config.gui
        if gui_boot
          boot_mode = "gui"
        else
          boot_mode = "nogui"
        end
        # restore boot mode
        `#{@vmwarecmd} -T ws start "#{@vmx_path}" #{boot_mode} `
      end

      def is_vm_created?
        return !@machine.id.nil?
      end

    end
  end
end
