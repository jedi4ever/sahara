require 'optparse'

module Sahara
  module Command
    class Status < Vagrant.plugin("2", :command) # < ::Vagrant::Command::Base

      def execute

        options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Shows the status of the sandbox"
          opts.separator ""
          opts.separator "Usage: vagrant sandbox status <vmname>"

        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        ses = Sahara::Session::Command.new(@app, @env)

        with_target_vms(argv, :reverse => true) do |machine|
          ses.status(machine)
        end
      end
    end
  end
end
