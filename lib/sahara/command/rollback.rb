module Sahara
  module Command
    class Rollback < Vagrant.plugin("2", :command) # < ::Vagrant::Command::Base
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

        ses = Sahara::Session::Command.new(@app, @env)

        with_target_vms(argv, :reverse => true) do |machine|
          ses.rollback(machine)
        end
      end
    end
  end
end
