require "optparse"

module Sahara
  module Command
    class On < Vagrant.plugin("2", :command)
      def execute

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Enters sandbox state"
          opts.separator ""
          opts.separator "Usage: vagrant sandbox on <vmname>"

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
            ses.on(machine)
          else
            puts "[#{machine.name}] Already sandbox mode"
          end

        end
      end
    end
  end
end
