require 'optparse'

module Sahara
  module Command
    class Status < ::Vagrant::Command::Base

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

        boxname=argv[0]
        begin
          Sahara::Session.status(boxname)
        end
      end
    end
  end
end
