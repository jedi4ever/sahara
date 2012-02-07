module Sahara
  module Command
    class Off < ::Vagrant::Command::Base
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

        boxname=argv[0]
        begin
          Sahara::Session.off(boxname)
        end
      end
    end
  end
end
