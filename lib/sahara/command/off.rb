module Sahara
  module Command
    class Off < Vagrant.plugin("2", :command)
      def execute

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Leaves sandbox state"
          opts.separator ""
          opts.separator "Usage: vagrant sandbox off <vmname>"

        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        ses = Sahara::Session::Command.new(@app, @env)

        with_target_vms(argv, :reverse => true) do |machine|
          ses.off(machine)
        end
      end
    end
  end
end
