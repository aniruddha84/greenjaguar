module Greenjaguar
  module Strategies
    class WaitStrategy
      attr_accessor :time_unit

      def initialize(*args)
        @time_unit = :sec # default value is seconds
      end

      def time_unit=(value)
        @time_unit = value
        reset_vars
      end

      def wait
        raise "wait not implemented by subclass"
      end

      def reset_vars
        raise "reset_vars not implemented by subclass. This method should be implemented by subclasses to init their wait time unit"
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