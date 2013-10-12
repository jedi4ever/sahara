module Sahara
  module Errors

    class SaharaError < Vagrant::Errors::VagrantError
      error_namespace("sahara.errors")
    end

  end
end
