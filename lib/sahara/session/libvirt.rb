require "fog/libvirt"

module Sahara
  module Session
    class Libvirt

      def initialize(machine)
        @machine=machine
        @sandboxname="sahara-sandbox"
        @connection=connect_to_libvirt
        @domain=get_domain
      end

      # based on VagrantPlugins::ProviderLibvirt::Action::ConnectLibvirt
      def connect_to_libvirt
        # Get config options for libvirt provider.
        config = @machine.provider_config

        # Setup connection uri.
        uri = config.driver
        if uri == "kvm"
          uri = "qemu"
        end

        if config.connect_via_ssh
          uri << '+ssh://'
          if config.username
            uri << config.username + '@'
          end

          if config.host
            uri << config.host
          else
            uri << 'localhost'
          end
        else
          uri << '://'
          uri << config.host if config.host
        end

        uri << '/system?no_verify=1'
        # set ssh key for access to libvirt host
        home_dir = `echo ${HOME}`.chomp
        uri << "&keyfile=#{home_dir}/.ssh/id_rsa"

        conn_attr = {}
        conn_attr[:provider] = 'libvirt'
        conn_attr[:libvirt_uri] = uri
        conn_attr[:libvirt_username] = config.username if config.username
        conn_attr[:libvirt_password] = config.password if config.password

        begin
          Fog::Compute.new(conn_attr)
        rescue Fog::Errors::Error => e
          raise Sahara::Errors::LibvirtConnectionError,
            :error_message => e.message
        end
      end

      def get_domain
        if is_vm_created?
          return @connection.client.lookup_domain_by_uuid(@machine.id)
        else
          return nil
        end
      end

      def get_snapshot_if_exists
        # if we can get snapshot description without exception it exists
        begin
          snapshot = @domain.lookup_snapshot_by_name(@sandboxname)
          snapshot_desc = snapshot.xml_desc
        rescue
          raise Sahara::Errors::SnapshotMissing
        end
        return snapshot
      end

      def is_snapshot_mode_on?
        begin
          snapshot = get_snapshot_if_exists
        rescue Sahara::Errors::SnapshotMissing
          return false
        end
        return true
      end

      def off
        snapshot = get_snapshot_if_exists
        begin
          snapshot.delete
        rescue Fog::Errors::Error => e
          raise Sahara::Errors::SnapshotDeletionError,
            :error_message => e.message
        end
      end

      def on
        snapshot_desc = <<-EOF
        <domainsnapshot>
          <name>sahara-sandbox</name>
          <description>Snapshot for vagrant sandbox</description>
        </domainsnapshot>
        EOF
        begin
          @domain.snapshot_create_xml(snapshot_desc)
        rescue Fog::Errors::Error => e
          raise Sahara::Errors::SnapshotCreationError,
            :error_message => e.message
        end
      end

      def commit
        off
        on
      end

      def rollback
        snapshot = get_snapshot_if_exists
        begin
          # 4 is VIR_DOMAIN_SNAPSHOT_REVERT_FORCE
          # needed due to https://bugzilla.redhat.com/show_bug.cgi?id=1006886
          @domain.revert_to_snapshot(snapshot, 4)
        rescue Fog::Errors::Error => e
          raise Sahara::Errors::SnapshotReversionError,
            :error_message => e.message
        end
      end

      def is_vm_created?
        return !@machine.id.nil?
      end

    end
  end
end
