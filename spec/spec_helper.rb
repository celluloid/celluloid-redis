require "celluloid/redis"
require "redis/connection/celluloid"
require "redis_instance"
require "coveralls"
Coveralls.wear!

def with_new_instance(opts = {})
  begin
    instance = RedisInstance.new(opts)
    instance.run
    yield instance
  ensure
    instance.stop
  end
end
