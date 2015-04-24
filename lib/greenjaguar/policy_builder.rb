module Greenjaguar
  class PolicyBuilder
    attr_accessor :count, :wait_strategy, :timeout, :logger, :strategy

    def initialize(&block)
      @count = 1
      @timeout = 300
      instance_eval(&block)
    end

    def retry_times(retry_count)
      @count = retry_count
      self
    end

    def should_timeout_after(retry_timeout)
      @timeout = retry_timeout
      self
    end

    def use_logger(logger)
      @logger = logger
      self
    end

    def measure_time_in(time_unit)
      @strategy.time_unit = time_unit
      self
    end

    def with_strategy(wait_strategy)
      @strategy = init_wait_strategy(wait_strategy)
      self
    end

    def wait
      strategy.wait
    end

    private

    def strategy
      @strategy ||= init_wait_strategy(:default)
    end

    def init_wait_strategy(wait_strategy)
      case wait_strategy
        when :fibonacci
          return Greenjaguar::Strategies::FibonacciStrategy.new
        when :exponential_backoff
          return Greenjaguar::Strategies::ExponentialBackoffStrategy.new
        when :random
          return Greenjaguar::Strategies::RandomStrategy.new
        else
          return Greenjaguar::Strategies::DefaultWaitStrategy.new
      end
    end
  end
end