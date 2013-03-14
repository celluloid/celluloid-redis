require "spec_helper"

describe Redis::Connection::Celluloid do
  it "connects to Redis" do
    connection = Redis.new(:driver => :celluloid)
    connection.should be_a Redis
  end
end