# -*- encoding: utf-8 -*-
# vim: set fileencoding=utf-8

require "vagrant"

module Sahara 
  class Plugin < Vagrant.plugin("2")
    name "sahara"
    description <<-DESC
    Sahara
    DESC

    command("sandbox") do
      setup_i18n
      require File.expand_path("../sahara/command/root", __FILE__)
      Command::Root
    end

    def self.setup_i18n
      I18n.load_path << File.expand_path('../../locales/en.yml', __FILE__)
      I18n.reload!
    end
  end
end
