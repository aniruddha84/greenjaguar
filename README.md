# Greenjaguar

Ruby Library to apply retry behavior to arbitrary code blocks with different policies like fibonacci,
exponential backoff, etc. This basically the 'retry' construct on steroids.

Potential uses are for accessing cloud-based services that experience transient faults. We should encapsulate our calls
with appropriate retry policies to make our applications more robust.

Features:
It currently supports following retry policies:
    * Default (no wait)
    * Fibonacci (wait times between retries increase in fibonacci sequence)
    * ExponentialBackOff (wait times increase using exponential backoff)
    * Random (wait times between retries vary between 0 - 5 secs)

You can specify the time unit for retry (:sec or :ms). Default is seconds.

If all retries fail, the last exception will be raised.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'greenjaguar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install greenjaguar

## Usage

    Greenjaguar::Retrier.run(5, :fibonacci) do
        Net::HTTP.get_response(URI.parse("http://www.example.com"))
    end

    Above code is passed to Greenjaguar which retries executes the block 6 times (first call + 5 retry attempts).
    If all calls fail, the last exception is raised.

## Issues

1. Need more tests.
2. Need implementation of more policies.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/greenjaguar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
