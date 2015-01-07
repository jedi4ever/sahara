module Sahara
  module Command
    class Rollback < Vagrant.plugin("2", :command)
      def execute

        options = {}
        options[:resume] = true

        opts = OptionParser.new do |opts|
          opts.banner = "Rollback changes since sandbox state was entered"
          opts.separator ""
          opts.separator "Usage: vagrant sandbox rollback <vmname>"

          opts.on("", "--[no-]resume", "Resume machine after rolling back changes") do |v|
              options[:resume] = v
          end

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
            puts "[#{machine.name}] Not sandbox mode now"
          else
            puts "[#{machine.name}] Rolling back the virtual machine..."
            ses.rollback(options[:resume])
          end
        end
      end
    end
  end
end
