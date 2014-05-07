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

    class SnapshotMissing < Sahara::Errors::Error
      error_key("snapshot_missing")
    end

    class SnapshotDeletionError < Sahara::Errors::Error
      error_key("snapshot_deletion_error")
    end

    class SnapshotCreationError < Sahara::Errors::Error
      error_key("snapshot_creation_error")
    end

    class SnapshotReversionError < Sahara::Errors::Error
      error_key("snapshot_reversion_error")
    end

    class HostOsNotSupported < Sahara::Errors::Error
      error_key("host_os_not_supported")
    end

  end
end
