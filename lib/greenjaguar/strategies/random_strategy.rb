module Greenjaguar
  module Strategies
    class RandomStrategy < WaitStrategy
      def initialize
        super
        @time_to_wait = 5 * convert_to(time_unit)
      end

      def wait
        rand(@time_to_wait)
      end
    end
  end
end
