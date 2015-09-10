Note: *Not Production ready yet*

# Greenjaguar

 Applies retry behavior to arbitrary code blocks with different policies like fibonacci,
exponential backoff, FixedInterval, etc. This basically is the 'retry' construct on steroids.

Potential uses are for accessing cloud-based services that experience transient faults. We should encapsulate our calls
with appropriate retry policies to make our applications more robust.

Features:
* It currently supports following retry policies:
    * Default (no wait)
    * Fibonacci (wait times between retries increase in fibonacci sequence)
    * ExponentialBackOff (wait times increase using exponential backoff)
    * Random (wait times between retries vary between 0 - 5 sec/ms)
    * FixedInterval (wait every 'n' sec/ms)
* You can specify the time unit for retry (:sec or :ms). Default is seconds.
* You can specify the Exception Types for which Retrier should execute. Default is all.
* You can specify that Retrier should fail silently (i.e. it wont raise any error if all retries fail)

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
```ruby
class Example
  include Greenjaguar

  def initialize
    @policy = PolicyBuilder.new do
      retry_times 10
      with_strategy :exponential_backoff
      measure_time_in :ms
      only_on_exceptions [Net::HTTPError]
    end
  end

  def some_method
    Retrier.run(@policy) do
      # Your code goes here
    end
  end
end
```
In the above example your code block is passed to Greenjaguar which executes it 11 times
(first call + 10 retry attempts, in case of failures).
If all calls fail, the last exception is raised. Retry happens only if the error raised is of the
specified type.

## Issues

1. Need more tests.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/greenjaguar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
