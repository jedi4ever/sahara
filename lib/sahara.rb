# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require "vagrant"
require File.expand_path("../sahara/session", __FILE__)

module Sahara 
  class Plugin < Vagrant.plugin("2")
    name "sahara"
    description <<-DESC
    Sahara
    DESC

    command("sandbox") do
      require File.expand_path("../sahara/command/root", __FILE__)
      Command::Root
    end
  end
end
