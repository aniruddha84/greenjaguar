module Greenjaguar
  module Strategies
    class ExponentialBackoffStrategy < WaitStrategy
      def initialize
        super
        @retry_interval = 0.5
        @randomization_factor = 0.5
      end

      def reset_vars
        @retry_interval = 0.5 * convert_to(time_unit)
        @randomization_factor = 0.5
      end

      def wait
        sleep @retry_interval
        @retry_interval += @retry_interval * ([1 - @randomization_factor,
                                            1 + @randomization_factor][random_index])
      end

      private
      def random_index
        rand(2)
      end
    end
  end
end
