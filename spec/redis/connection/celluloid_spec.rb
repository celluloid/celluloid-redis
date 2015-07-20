RSpec.describe Redis::Connection::Celluloid do
  let(:example_key)   { 'foobar' }
  let(:example_value) { 'baz' }

  it "connects to Redis" do
    redis = Redis.new(:driver => :celluloid)

    # FIXME: perhaps some better tests are in order here?
    redis.set(example_key, '')
    expect(redis.get(example_key)).to eq('')

    redis.set(example_key, example_value)
    expect(redis.get(example_key)).to eq(example_value)
  end

  it "cleanly shuts down an instance" do
    with_new_instance do |instance|
      redis = Redis.new(:port => instance.port, :driver => :celluloid)
      expect { redis.shutdown }.not_to raise_error
    end
  end
end
