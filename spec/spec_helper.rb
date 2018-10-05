require "celluloid/redis"

require "redis_instance"
require "coveralls"
Coveralls.wear!

RSpec.configure(&:disable_monkey_patching!)

# Trick to test new redis-rb connection driver
# that must load redis/connection/celluloid
Redis.new(driver: :celluloid)

def with_new_instance(opts = {})
  begin
    instance = RedisInstance.new(opts)
    instance.run
    yield instance
  ensure
    instance.stop
  end
end
