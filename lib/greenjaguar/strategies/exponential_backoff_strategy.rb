module Greenjaguar
  module Strategies
    class ExponentialBackoffStrategy < WaitStrategy
      def initialize
        super
        @time_to_wait = 2 * convert_to(time_unit)
        @retry_interval = 0.5
        @randomization_factor = 0.5
      end

      def wait
        sleep @time_to_wait
        @time_to_wait = @retry_interval * ([1 - @randomization_factor,
                                            1 + @randomization_factor][random_index])
      end

      private
      def random_index
        rand(2)
      end
    end
  end
end
