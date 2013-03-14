class Redis
  class Client
    # Well this is really sad. redis-rb does not provide extensible driver
    # support. Instead they couple everything together though this method.
    # This leaves us no choice but to monkeypatch
    def _parse_driver(driver)
      driver = driver.to_s if driver.is_a?(Symbol)

      if driver.kind_of?(String)
        case driver
        when "ruby"
          require "redis/connection/ruby"
          driver = Connection::Ruby
        when "celluloid"
          require "redis/connection/celluloid"
          driver = Connection::Celluloid
        when "hiredis"
          require "redis/connection/hiredis"
          driver = Connection::Hiredis
        else
          raise "Unknown driver: #{driver}"
        end
      end

      driver
    end
  end
end