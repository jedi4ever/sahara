require "sahara/errors"

module Sahara
  module Session
    class Factory
      def self.create(machine)
        case machine.provider_name
        when :virtualbox
          require_relative "virtualbox"
          Virtualbox.new(machine)
        when :libvirt
          require_relative "libvirt"
          ProviderLibvirt.new(machine)
        when :parallels
          require_relative "parallels"
          Parallels.new(machine)
        when :kvm
	        require_relative "kvm"
	        Kvm.new(machine)
        else
          raise Sahara::Errors::ProviderNotSupported
        end
      end
    end
  end
end
