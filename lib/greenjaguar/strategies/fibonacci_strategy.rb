module Greenjaguar
  module Strategies
    class FibonacciStrategy < WaitStrategy
      def initialize
        super
        @prev_time_to_wait = 1 * convert_to(time_unit)
        @time_to_wait = @prev_time_to_wait
      end

      def wait
        sleep @time_to_wait
        new_time = @prev_time_to_wait + @time_to_wait
        @prev_time_to_wait = @time_to_wait
        @time_to_wait = new_time
      end
    end
  end
end


