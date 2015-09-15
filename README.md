
# Greenjaguar [![Build Status](https://travis-ci.org/aniruddha84/greenjaguar.svg?branch=master)](https://travis-ci.org/aniruddha84/greenjaguar)

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
class YourClass
  include Greenjaguar

  def your_method
    # Build retry policy
    @policy = build_policy do
        times 10
        with_strategy :exponential_backoff
        measure_time_in :ms
        only_on_exceptions [Net::HTTPError]
    end

    # Executes your code using the policy
    robust_retry(@policy) do
      # Your code goes here
    end
  end
end
```
In the above example your code block is passed to Greenjaguar which executes it 11 times
(first call + 10 retry attempts, in case of failures).
If all calls fail, the last exception is raised. Retry happens only if the error raised is of the
specified type.

## Available Options explained
- times: Number of retry attempts
- with_strategy: Retry Strategy to use. Greenjaguar currently supports following
    - exponential_backoff: wait times after each failed retry will increase exponentially. This is the standard
     used in most of the industry's retry policies.
    - fibonacci: wait times increase in fibonacci series.
    - fixed_interval: wait times between retries are fixed.
    - random: wait times are randomly selected between 0 to 5 secs.
  Skip this option if you want immediate retries.
- measure_time_in: wait times can be in either sec or ms.
- only_on_exceptions: Provide the Exception Types for which Greenjaguar should retry. Default is all.
- fail_silently: Will fail silently without raising any exceptions after all retries fail.
- never_give_up: Retry will continue indefinitely or until there is success.
- timeout_after: Set a timeout period after which Greenjaguar should quit and just raise the exception.

Refer spec/greenjaguar_spec.rb to se examples of using the options.

## Issues

1. Need more tests.
2. Need logo.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/greenjaguar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
