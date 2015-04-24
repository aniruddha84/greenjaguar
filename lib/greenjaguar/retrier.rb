module Greenjaguar
  class Retrier

    def initialize(policy, &block)
      @policy = policy
      @retry_block = block
    end

    class << self
      def run(policy, &block)
        self.new(policy, &block).exec
      end
    end

    def exec
      @start_time = Time.new
      begin
        @retry_block.call
      rescue
        if infinite_retry?
          @policy.wait
          retry
        else
          if time_out? || retry_count_reached?
            raise
          else
            decrement_retry_count
            @policy.wait
            retry
          end
        end
      end
    end

    private

    def infinite_retry?
      @policy.count == -1
    end

    def time_out?
      Time.now - @start_time > @policy.timeout
    end

    def decrement_retry_count
      @policy.count -= 1
    end

    def retry_count_reached?
      @policy.count == 0
    end
  end
end
