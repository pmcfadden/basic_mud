basic_mud
=========

# ClasslessMud

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'classless_mud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install classless_mud

## Usage

Generate example configuration settings with:

    bundle exec classless_mud scaffold

Import config and setup database:

    bundle exec classless_mud init

Start the server:

    bundle exec classless_mud start


## Contributing

1. Fork it ( https://github.com/[my-github-username]/classless_mud/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Dev setup

#### Server

    bundle
    ./bin/classless_mud scaffold
    ./bin/classless_mud init
    ./bin/classless_mud start

#### Client

    telnet localhost 2000
