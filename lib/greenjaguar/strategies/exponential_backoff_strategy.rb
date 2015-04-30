module Greenjaguar
  module Strategies
    class ExponentialBackoffStrategy < WaitStrategy
      def initialize
        super
        @retry_interval = 0.5
        @randomization_factor = 0.5
        @retry_count = 0
      end

      def reset_vars
        @retry_interval = 0.5 * convert_to(time_unit)
        @randomization_factor = 0.5
      end

      def wait
        sleep @retry_interval
        @retry_count += 1
        increment = (2 ** @retry_count - 1) * ([1 - @randomization_factor,
                                            1 + @randomization_factor][random_index])
        @retry_interval += increment * convert_to(time_unit)
      end

      private
      def random_index
        rand(2)
      end
    end
  end
end
