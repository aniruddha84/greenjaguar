require "greenjaguar/version"

module Greenjaguar
  class Retrier
    class << self
      def run(retry_count = 1, wait_strategy = :default_wait, stop_strategy = :s1, &block)
        n = retry_count
        strategy = init_wait_strategy(wait_strategy)
        begin
          block.call
          n -= 1
        rescue
          if n >= 0
            strategy.wait
            retry
          end
        end
      end

      def init_wait_strategy(wait_strategy)
        case wait_strategy
          when :fibonacci
            return FibonacciStrategy.new
          when :exponential_backoff
            return ExponentialBackoffStrategy.new
          else
            return DefaultWaitStrategy.new
        end
      end

    end
  end
end
