require "spec_helper"

describe Redis::Connection::Celluloid do
  let(:example_key)   { 'foobar' }
  let(:example_value) { 'baz' }

  it "connects to Redis" do
    redis = Redis.new(:driver => :celluloid)

    # FIXME: perhaps some better tests are in order here?
    redis.set(example_key, '')
    redis.get(example_key).should eq ''

    redis.set(example_key, example_value)
    redis.get(example_key).should eq example_value
  end

  it "cleanly shuts down an instance" do
    with_new_instance do |instance|
      redis = Redis.new(:port => instance.port, :driver => :celluloid)
      expect { redis.shutdown }.not_to raise_error
    end
  end

  describe "using inside Celluloid::IO" do
    before do
      class Incrementor
        include Celluloid::IO

        def initialize
          @redis = Redis.new(:driver => :celluloid)
        end

        def increment!
          sleep(rand / 10)
          @redis.incr 'rabbits'
        rescue
          STDERR.puts "I cannot increment rabbits because of #{$!.inspect}!"
          raise RuntimeError
        end
      end
    end

    let(:actor) {
      Incrementor.new
    }
    let(:count) { 1000 }

    it "just survives" do
      redis = Redis.new
      redis.set 'rabbits', 0

      count.times do
        actor.async.increment! rescue nil
      end
      sleep 10
      expect(redis.get 'rabbits').to eq(count.to_s)
    end
  end
end
