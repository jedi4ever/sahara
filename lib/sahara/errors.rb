module Sahara
  module Errors

    class Error < Vagrant::Errors::VagrantError
      error_namespace("sahara.errors")
    end

    class ProviderNotSupported < Sahara::Errors::Error
      error_key("provider_not_supported")
    end

    class LibvirtConnectionError < Sahara::Errors::Error
      error_key("libvirt_connection_error")
    end

  end
end
