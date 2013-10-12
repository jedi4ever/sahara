require "sahara/errors"

module Sahara
  module Session
    class Factory
      def self.create(machine)
        case machine.provider_name
        when :virtualbox
          require_relative "virtualbox"
          Virtualbox.new(machine)
        else
          raise Sahara::Errors::SaharaError,
            :error_message => "#{provider_name} is not supported"
        end
      end
    end
  end
end
