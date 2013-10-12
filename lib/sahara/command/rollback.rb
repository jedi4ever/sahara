module Sahara
  module Command
    class Rollback < Vagrant.plugin("2", :command)
      def execute

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Rollback changes since sandbox state was entered"
          opts.separator ""
          opts.separator "Usage: vagrant sandbox rollback <vmname>"

        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        require "sahara/session/virtualbox"
        ses = Sahara::Session::Virtualbox.new

        with_target_vms(argv, :reverse => true) do |machine|

          if !ses.is_vm_created?(machine) then
            puts "[#{machine.name}] VM is not created"
            next
          end
          if !ses.is_snapshot_mode_on?(machine) then
            puts "[#{machine.name}] Not sandbox mode now"
            next
          end
          ses.rollback(machine)

        end
      end
    end
  end
end
