require "redis"

require "celluloid/redis/version"
require "celluloid/io"

module Celluloid
  class Redis < ::Redis
    VERSION = CelluloidRedis::VERSION

    def initialize(*args)
      super
      if @options[:driver] == :celluloid
        @latch = Celluloid::IO::Stream::Latch.new
      end
    end

    def synchronize
      if @latch
        @latch.synchronize { yield @client }
      else
        super(&proc)
      end
    end
  end
end
