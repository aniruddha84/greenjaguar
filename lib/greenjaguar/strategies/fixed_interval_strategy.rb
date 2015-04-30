module Greenjaguar
  module Strategies
    class FixedIntervalStrategy < WaitStrategy
      def initialize(*args)
        super
        @time_to_wait = args[0]
      end

      def reset_vars
        @time_to_wait = @time_to_wait * convert_to(time_unit)
      end

      def wait
        sleep @time_to_wait
      end
    end
  end
end
