class RedisInstance
  def initialize(opts = {})
    @opts = {:port => 6400, :cmd => 'redis-server'}.merge(opts)
  end

  def host
    @opts[:host]
  end

  def port
    @opts[:port]
  end

  def stop 
    return unless @pid
    begin
      Process.kill('SIGTERM', @pid)
    rescue Errno::ESRCH
    end
  end

  def run
    @pid = spawn(@opts[:cmd], "--port #{port}", "--daemonize yes")
    wait_until_useable
  end

  private
  def wait_until_useable
    begin
      TCPSocket.open('localhost', port)
    rescue Errno::ECONNREFUSED
      retry
    end
  end
end
