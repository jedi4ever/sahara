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

        with_target_vms(argv, :reverse => true) do |machine|

          ses = Sahara::Session::Factory.create(machine)
          if !ses.is_vm_created? then
            puts "[#{machine.name}] VM is not created"
            next
          end
          if !ses.is_snapshot_mode_on? then
            puts "[#{machine.name}] Starting sandbox mode..."
            ses.on
          else
            puts "[#{machine.name}] Already sandbox mode"
          end

        end
      end
    end
  end
end
