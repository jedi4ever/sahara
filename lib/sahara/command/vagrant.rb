require 'sahara'
require 'sahara/session'
require 'sahara/command/sandbox'

Vagrant.commands.register(:sandbox) { Sahara::Command::Sandbox }
