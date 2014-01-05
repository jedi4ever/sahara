require "libvirt"

module Sahara
  module Session
    class Kvm

      def initialize(machine)
        @machine=machine
        @sandboxname="sahara-sandbox"
      	@conn=get_connection
        @domain=get_domain
      end

      def get_connection
        begin
          Libvirt::open('qemu:///system')
      	rescue Libvirt::Error => e
          if e.libvirt_code == 5
            raise Sahara::Errors::LibvirtConnectionError
          else
            raise e
          end
        end
      end

      def get_domain
        if is_vm_created?
          return @conn.lookup_domain_by_uuid(@machine.id)
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
        rescue Libvirt::Error => e
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
        rescue Libvirt::Error => e
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
        rescue Libvirt::Error => e
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
