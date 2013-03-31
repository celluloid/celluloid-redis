require "redis/connection/registry"
require "redis/connection/command_helper"
require "redis/errors"
require "celluloid/io"

class Redis
  module Connection
    class Celluloid
      include Redis::Connection::CommandHelper

      MINUS    = "-".freeze
      PLUS     = "+".freeze
      COLON    = ":".freeze
      DOLLAR   = "$".freeze
      ASTERISK = "*".freeze

      def self.connect(config)
        # TODO: config[:timeout] support
        if config[:scheme] == "unix"
          sock = ::Celluloid::IO::UNIXSocket.open(config[:path])
        else
          sock = ::Celluloid::IO::TCPSocket.open(config[:host], config[:port])
        end

        new(sock)
      end

      def initialize(sock)
        @sock = sock
      end

      def connected?
        !!@sock
      end

      def disconnect
        @sock.close rescue nil
      ensure
        @sock = nil
      end

      def timeout=(timeout)
        if @sock.respond_to?(:timeout=)
          @sock.timeout = timeout
        end
      end

      def write(command)
        @sock.write(build_command(command))
      end

      def read
        line = @sock.gets
        raise Errno::ECONNRESET unless line
        reply_type = line.slice!(0, 1)
        format_reply(reply_type, line)

      rescue Errno::EAGAIN
        raise TimeoutError
      end

      def format_reply(reply_type, line)
        case reply_type
        when MINUS    then format_error_reply(line)
        when PLUS     then format_status_reply(line)
        when COLON    then format_integer_reply(line)
        when DOLLAR   then format_bulk_reply(line)
        when ASTERISK then format_multi_bulk_reply(line)
        else raise ProtocolError.new(reply_type)
        end
      end

      def format_error_reply(line)
        CommandError.new(line.strip)
      end

      def format_status_reply(line)
        line.strip
      end

      def format_integer_reply(line)
        line.to_i
      end

      def format_bulk_reply(line)
        bulklen = line.to_i
        return if bulklen == -1
        reply = encode(@sock.read(bulklen))
        @sock.read(2) # Discard CRLF.
        reply
      end

      def format_multi_bulk_reply(line)
        n = line.to_i
        return if n == -1

        Array.new(n) { read }
      end
    end
  end
end

Redis::Connection.drivers << Redis::Connection::Celluloid
