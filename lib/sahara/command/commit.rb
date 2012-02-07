module Sahara
  module Command
    class Commit < ::Vagrant::Command::Base
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

        boxname=argv[0]
        begin
          Sahara::Session.commit(boxname)
        end
      end
    end
  end
end
