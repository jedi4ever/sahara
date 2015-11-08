require 'json'

module Sahara
  module Session
    class DigitalOcean

      def initialize(machine)
        @machine = machine
        @id = @machine.id
        @client = Client.new(@machine.provider_config.token)
        @sandboxname = "sahara-sandbox"
      end

      def list_snapshots
        result = @client.get("/v2/images", private: true)
        result.fetch("images", []).select { |image| image["name"] == @sandboxname }
      end

      def is_snapshot_mode_on?
        !list_snapshots.empty?
      end

      def off
        list_snapshots.each do |snapshot|
          @client.delete("/v2/images/#{snapshot["id"]}")
        end
      end

      def on
        shutdown
        sleep 5 # because DO might error out if we try to snapshot immediately
        snapshot
      end

      def commit
        off
        on
      end

      def rollback
        snapshots = list_snapshots
        return if snapshots.empty?
        snapshot = snapshots.last
        result = @client.post("/v2/droplets/#{@id}/actions", type: "restore", image: snapshot["id"])
        wait_on result["action"]
      end

      def is_vm_created?
        !@id.nil?
      end

      private

      def shutdown
        result = @client.post("/v2/droplets/#{@id}/actions", type: "shutdown")
        wait_on result["action"]
      end

      def snapshot
        result = @client.post("v2/droplets/#{@id}/actions",
                              type: "snapshot",
                              name: @sandboxname)
        wait_on result["action"]
      end

      def wait_on(action)
        @client.wait_for_event action["id"] if action
      end

      class Client
        include Vagrant::Util::Retryable

        DIGITALOCEAN_API = "https://api.digitalocean.com"

        def initialize(token)
          @token = token
        end

        def get(path, params = {})
          uri = URI.join(DIGITALOCEAN_API, path)
          uri.query = URI.encode_www_form params if !params.empty?

          http = connect uri

          request = Net::HTTP::Get.new(uri.request_uri, headers)

          response = http.request(request)
          JSON.load response.body
        end

        def post(path, body = {})
          uri = URI.join(DIGITALOCEAN_API, path)

          http = connect uri

          request = Net::HTTP::Post.new(uri.request_uri, headers)
          request.body = JSON.generate body

          response = http.request(request)
          JSON.load response.body
        end

        def delete(path)
          uri = URI.join(DIGITALOCEAN_API, path)
          http = connect uri
          request = Net::HTTP::Delete.new(uri.request_uri, headers)
          response = http.request(request)
          !response.code.match(/2\d\d/).nil?
        end

        def wait_for_event(id)
          retryable(:tries => 120, :sleep => 15) do
            # check action status
            result = get("/v2/actions/#{id}")

            yield result if block_given?
            raise "not ready" if result["action"]["status"] != "completed"
          end
        end

        private

        def connect(uri)
          http = Net::HTTP.new uri.host, uri.port
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          http
        end

        def headers
          {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{@token}"
          }
        end
      end
    end
  end
end
