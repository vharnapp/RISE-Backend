if ENV['RAILS_ENV'] == 'development' && ENV['NGROK'] == 'true'
  # require 'ngroker/version'

  module Ngroker
    require 'rubygems'
    require 'active_support'
    require 'active_support/core_ext/object/blank'
    require 'active_support/core_ext/object/try'
    require 'json'

    class << self
      def url
        ::Rails.logger.error('NOT AVAILABLE IN CONSOLE') if ::Rails.const_defined?('Console')
        if ::Rails.const_defined?('Server') && ::Rails.env.development?
          api_port = find_ngrok_api_port_for_rails_server_port

          if api_port.present?
            logger.info 'Looking up existing Ngrok...'
          else
            logger.info 'Booting Ngrok...'

            # NOTE: this runs ngrok in the background. Kill all your user's ngrok
            # instances with: `pkill -u "$(whoami)" -x ngrok`. However, ngrok
            # should shutdown gracefully when stopping the rails server with ctrl-c
            system("ngrok http #{rails_server_port} > /dev/null &")

            # Only try to boot ngrok for ~5 seconds...then raise an error
            5.times do
              api_port = find_ngrok_api_port_for_rails_server_port
              break if api_port.present?
              sleep 1
            end

            raise StandardError, 'NGROK FAILED TO SYNC WITH RAILS PORT' if api_port.blank?
          end

          display_log_message(api_port)
          ngrok_url(api_port)
        end
      rescue => e
        raise StandardError, %(
          Please make sure ngrok is installed and executable at
          /usr/local/bin/ngrok. If you continue to receive this message, look for
          existing ngrok processes with `ps ux | grep "[n]grok"`. You may need to
          kill existing ngrok processes to continue. Error: #{e.inspect}
        ).squish
      end

      def find_ngrok_api_port_for_rails_server_port(rsp=rails_server_port, echo: false)
        web_interface_port = ngrok_web_interface_ports_in_use.select do |port|
          tunnel_obj = parse_ngrok_tunnel_list(port: port)
          tunnel_obj.try(:fetch, 'config').try(:fetch, 'addr').to_s.include?(rsp.to_s)
        end.first

        puts web_interface_port and return if echo
        web_interface_port
      end

      def ngrok_url(api_port, echo: false)
        url = parse_ngrok_tunnel_list(port: api_port)['public_url']
        puts url and return if echo
        url
      end

      private

      def parse_ngrok_tunnel_list(port:)
        tunnel_details = tunnel_list(port)

        error_message = "NO TUNNEL DETAILS FOUND FOR PORT: #{port}"
        raise StandardError, error_message if tunnel_details.blank?

        tunnel_array = JSON.parse(tunnel_details)

        tunnel_array['tunnels'].select do |tunnel|
          tunnel['proto'] == 'https'
        end.first
      end

      def tunnel_list(port)
        `curl --silent http://127.0.0.1:#{port}/api/tunnels`
      end

      def rails_server_port
        port = Rack::Server.new.options[:Port].to_s
        @port ||= if port == '9292'
                    '3000'
                  else
                    port
                  end
      end

      def ngrok_web_interface_ports_in_use
        if RUBY_PLATFORM.downcase.include?('linux')
          `netstat -l | grep -P "40[4-6][0-9]\s" | awk '{ print $4 }' | cut -d: -f2 | sort -u`
            .split("\n")
            .sort
            .map(&:strip)
        else
          `lsof -nP | grep TCP | grep -Eo '404[0-5]\s' | sort | uniq`
            .split("\n")
            .sort
            .map(&:strip)
        end
      end

      def display_log_message(api_port)
        web_interface_url = "http://127.0.0.1:#{api_port}"

        message = %(
          NGROK URL: #{ngrok_url(api_port)} |
          WEB INTERFACE: #{web_interface_url}
        ).squish

        logger.info "\n\n#{'*' * 75}\n#{message}\n#{'*' * 75}\n"
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
