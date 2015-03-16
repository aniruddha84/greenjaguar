require_relative 'wait_strategy'

class DefaultWaitStrategy < WaitStrategy
  def initialize
    @time_to_wait = 0
  end

  def wait
    sleep @time_to_wait
  end
end