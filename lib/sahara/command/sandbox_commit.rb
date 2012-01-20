require 'optparse'
require 'sahara/session'

module Sahara
  module Command
    class SandboxCommit < Vagrant::Command::Base
      def initialize(argv, env)
        super

        @session = Sahara::Session.new(@env)

        @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)
      end

      def execute
        @session.commit(@sub_args.size == 0 ? nil: @sub_args[1])
      end

      def help
        @env.ui.info("Usage: vagrant sandbox commit [<name>]")
      end
    end
  end
end
