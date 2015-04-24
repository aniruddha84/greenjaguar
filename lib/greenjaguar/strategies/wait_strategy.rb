module Greenjaguar
  module Strategies
    class WaitStrategy
      attr_accessor :time_unit

      def initialize
        @time_unit = :sec
      end

      def wait
        raise "wait not implemented by subclass"
      end

      def convert_to(time_unit)
        if time_unit == :sec
          1
        else
          0.001
        end
      end
    end
  end
end