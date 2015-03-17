module Greenjaguar
  module Strategies
    class ExponentialBackoffStrategy < WaitStrategy
      def initialize
        @time_to_wait = 0
      end

      def wait
        raise "not implemented"
      end
    end
  end
end
