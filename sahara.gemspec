# -*- encoding: utf-8 -*-
require File.expand_path("../lib/sahara/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sahara"
  s.version     = Sahara::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Debois"]
  s.email       = ["patrick.debois@jedi.be"]
  s.homepage    = "http://github.com/jedi4ever/sahara/"
  s.summary     = %q{Vagrant box creation}
  s.description = %q{Allows you to sandbox your vagrant}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "sahara"

  s.add_dependency "popen4", "~> 0.1.2"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
