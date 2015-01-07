module Sahara
  module Session
    class Parallels

      def initialize(machine)
        @machine=machine
        @instance_id = @machine.id
        @prlctl="prlctl"
        @sandboxname="sahara-sandbox"
        @snapshots=list_snapshots
      end

      def list_snapshots
        snapshotlist = Hash.new
        output = `#{@prlctl} snapshot-list "#{@instance_id}" --tree`
        snapshot_ids=output.scan(/\{([\w-]*)?\}/).flatten
        snapshot_ids.each do |id|
          res = `#{@prlctl} snapshot-list "#{@instance_id}" -i "#{id}"`
          if res =~ (/^Name:\s(.*)$/)
            snapshotlist[$1] = id
          end
        end
        snapshotlist
      end

      def get_snapshot_id
        # if we can get snapshot description without exception it exists
        begin
          snapshot_id = @snapshots.fetch(@sandboxname)
        rescue
          raise Sahara::Errors::SnapshotMissing
        end
        return snapshot_id
      end

      def is_snapshot_mode_on?
        begin
          snapshot_id = get_snapshot_id
        rescue Sahara::Errors::SnapshotMissing
          return false
        end
        return true
      end

      def off
        snapshot_id = get_snapshot_id
        `#{@prlctl} snapshot-delete "#{@instance_id}" --id "#{snapshot_id}" `
      end

      def on
        `#{@prlctl} snapshot "#{@instance_id}" --name "#{@sandboxname}"`
      end

      def commit
        off
        on
      end

      def rollback(resume)
        snapshot_id = get_snapshot_id
        command = "#{@prlctl} snapshot-switch \"#{@instance_id}\" --id \"#{snapshot_id}\" "
        command << " --skip-resume" if !resume
        `#{command}`
      end

      def is_vm_created?
        return !@machine.id.nil?
      end

    end
  end
end
