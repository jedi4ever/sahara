module Sahara
  module Command
    class Rollback < ::Vagrant::Command::Base
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

        boxname=argv[0]
        begin
          Sahara::Session.rollback(boxname)
        end
      end
    end
  end
end
