[![Build Status](https://secure.travis-ci.org/travisdahlke/mongoid_retry.png)](http://travis-ci.org/travisdahlke/mongoid_retry)

# MongoidRetry

Overcome duplicate key errors in MongoDB by catching the exception, finding the existing document, and updating it instead.
This is currently only compatible with Mongoid 2.x.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_retry'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_retry

## Usage

```
class Fruit
  include Mongoid::Document
  include Mongoid::MongoidRetry

  field :name
  index :type, unique: true
end
```

    Fruit.new(type: 'apple').save_and_retry

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
