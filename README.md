# MongoidRetry [![Build Status](https://travis-ci.org/travisdahlke/mongoid_retry.png?branch=master)](https://travis-ci.org/travisdahlke/mongoid_retry) [![Gem Version](https://badge.fury.io/rb/mongoid_retry.svg)](http://badge.fury.io/rb/mongoid_retry)

Overcome duplicate key errors in MongoDB by catching the exception, finding the existing document, and updating it instead.
Compatible with Mongoid 2 and 3.

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

 `#save_and_retry` takes a hash of options:

 - `:retries` Specifies the number of times to retry before failing. Defaults to 3.
 - `:allow_delete` If true, this will delete any conflicting documents if a duplicate key error is encountered.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
