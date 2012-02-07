begin
  require 'vagrant'
  require 'sahara/command/vagrant'
rescue LoadError
  require 'rubygems'
  require 'vagrant'
  require 'sahara/command/vagrant'
end
