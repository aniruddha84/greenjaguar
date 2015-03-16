require_relative 'wait_strategy'

class FibonacciStrategy < WaitStrategy
  def initialize
    @prev_time_to_wait = 1
    @time_to_wait = 1
  end

  def wait
    sleep @time_to_wait
    new_time = @prev_time_to_wait + @time_to_wait
    @prev_time_to_wait = @time_to_wait
    @time_to_wait = new_time
  end
end

