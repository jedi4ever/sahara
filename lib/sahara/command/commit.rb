module Sahara
  module Command
    class Commit < Vagrant.plugin("2", :command)
      def execute

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Commits changes - moves sandbox initial state to currentstate"
          opts.separator ""
          opts.separator "Usage: vagrant sandbox commit <vmname>"

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
          if ses.is_snapshot_mode_on? then
            puts "[#{machine.name}] Committing the virtual machine..."
            ses.commit
          else
            puts "[#{machine.name}] Not sandbox mode now"
          end

        end
      end
    end
  end
end
