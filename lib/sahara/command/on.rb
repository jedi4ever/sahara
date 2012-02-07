module Sahara
  module Command
    class On < ::Vagrant::Command::Base
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

        boxname=argv[0]
        begin
          Sahara::Session.on(boxname)
        end
      end
    end
  end
end
