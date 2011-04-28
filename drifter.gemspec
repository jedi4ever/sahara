# -*- encoding: utf-8 -*-
require File.expand_path("../lib/drifter/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "drifter"
  s.version     = Drifter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Debois"]
  s.email       = ["patrick.debois@jedi.be"]
  s.homepage    = "http://github.com/jedi4ever/drifter/"
  s.summary     = %q{Vagrant box creation}
  s.description = %q{Allows you to sandbox your vagrant}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "drifter"

  s.add_dependency "vagrant", "~> 0.7.0"
  s.add_dependency "net-ssh", "~> 2.1.0"
  s.add_dependency "popen4", "~> 0.1.2"
  s.add_dependency "thor", "~> 0.14.6"
  s.add_dependency "highline", "~> 1.6.1"
  s.add_dependency "progressbar"
  s.add_dependency "cucumber", "0.8.5"
  s.add_dependency "rspec", "~> 2.5.0"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

