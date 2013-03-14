Celluloid::Redis
================
[![Build Status](https://secure.travis-ci.org/celluloid/celluloid-redis.png?branch=master)](http://travis-ci.org/celluloid/celluloid-redis)
[![Dependency Status](https://gemnasium.com/celluloid/celluloid-redis.png)](https://gemnasium.com/celluloid/celluloid-redis)
[![Code Climate](https://codeclimate.com/github/celluloid/celluloid-redis.png)](https://codeclimate.com/github/celluloid/celluloid-redis)

A [Celluloid::IO][celluloidio]-based connection backend for the
[redis-rb][redisrb] gem, providing "evented" connection support that can
multiplex long-lived blocking calls like pub/sub and blpop(rpush) with the
Celluloid message protocol.

[celluloidio]: https://github.com/celluloid/celluloid-io
[redisrb]: https://github.com/redis/redis-rb

## Why?

Is Celluloid going down the same path as EventMachine, requiring
`Celluloid::IO`-specific support for each library that touches the network?

Ideally, no! `Celluloid::IO::TCPSocket` is a duck type of Ruby's `TCPSocket`,
and where libraries provide a dependency injection API for the socket
class to use, it should be possible to use `Celluloid::IO` as a drop-in
replacement. An example of a library with an API like this is 'net/ssh',
which allows an `option[:proxy]` which (though oddly named) allows the
API user to dependency inject their own socket class.

The situation with redis-rb is a bit more... gnarly. Different socket
backends are provided for Ruby versus JRuby, for example, and no
dependency injection API is provided out-of-the-box.

The goal of `celluloid-redis` is to provide a stable Redis connection
backend which works across multiple Ruby platforms using a
`Celluloid::IO`-based socket backend.

Ideally this adapter can also leverage other Celluloid features to provide
nifty things like timeouts that actually work!

## Installation

Add this line to your application's Gemfile:

    gem 'celluloid-redis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install celluloid-redis

Require it in your Ruby application with:

    require 'celluloid/redis'

## Usage

When instantiating the client object, specify `:celluloid`:

```ruby
redis = Redis.new(:driver => :celluloid)
```

## Contributing

* Fork this repository on github
* Make your changes and send us a pull request
* If we like them we'll merge them
* If we've accepted a patch, feel free to ask for commit access

## License

Copyright (c) 2013 Tony Arcieri. Distributed under the MIT License. See
LICENSE.txt for further details.
