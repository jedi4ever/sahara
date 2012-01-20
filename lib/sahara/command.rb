module Sahara
  module Command
    autoload :Sandbox,      'sahara/command/sandbox'
    autoload :SandboxStatus,      'sahara/command/sandbox_status'
    autoload :SandboxOn,      'sahara/command/sandbox_on'
    autoload :SandboxCommit,      'sahara/command/sandbox_commit'
    autoload :SandboxRollback,      'sahara/command/sandbox_rollback'
    autoload :SandboxOff,      'sahara/command/sandbox_off'

    Vagrant.commands.register(:sandbox) { Sahara::Command::Sandbox }
  end
end
