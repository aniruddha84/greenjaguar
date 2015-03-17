
module Greenjaguar
  class Retrier
    class << self
      def run(retry_count = 1, wait_strategy = :default_wait, stop_strategy = :s1, &block)

        strategy = init_wait_strategy(wait_strategy)
        begin
          block.call
        rescue
          if retry_count >= 1
            retry_count -= 1
            strategy.wait
            retry
          end
        end
      end

      private
      def init_wait_strategy(wait_strategy)
        case wait_strategy
          when :fibonacci
            return Greenjaguar::Strategies::FibonacciStrategy.new
          when :exponential_backoff
            return Greenjaguar::Strategies::ExponentialBackoffStrategy.new
          else
            return Greenjaguar::Strategies::DefaultWaitStrategy.new
        end
      end
    end
  end
end