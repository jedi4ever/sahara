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

        ses = Sahara::Session::Command.new(@app, @env)

        with_target_vms(argv, :reverse => true) do |machine|
          ses.commit(machine)
        end
      end
    end
  end
end
