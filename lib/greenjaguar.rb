require 'greenjaguar/version'
require 'greenjaguar/strategies/wait_strategy'
require 'greenjaguar/strategies/default_wait_strategy'
require 'greenjaguar/strategies/fibonacci_strategy'
require 'greenjaguar/strategies/exponential_backoff_strategy'
require 'greenjaguar/strategies/fixed_interval_strategy'
require 'greenjaguar/policy_builder'
require 'greenjaguar/retrier'

module Greenjaguar

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def build_policy(&block)
      PolicyBuilder.new(&block)
    end

    def robust_retry(policy, &block)
      Retrier.new(policy, &block)
    end
  end
end