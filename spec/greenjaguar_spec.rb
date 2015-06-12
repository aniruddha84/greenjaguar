require 'spec_helper'

module Specs
  include Greenjaguar

  describe Greenjaguar do
    before do
      @stub = stub_request(:get, "http://www.example.com").to_raise("some error")
    end

    after do
      WebMock.reset!
    end

    it '#run should call the passed code block 4 times' do
      policy = PolicyBuilder.new do
        retry_times 3
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
      assert_requested :get, "http://www.example.com", :times => 4
    end

    it '#run should call the passed code block only 1 time if successful response is received' do
      @stub = stub_request(:get, "http://www.example.com")

      policy = PolicyBuilder.new do
        retry_times 3
      end

      Retrier.run(policy) do
        Net::HTTP.get_response(URI.parse("http://www.example.com"))
      end
      assert_requested :get, "http://www.example.com", :times => 1
    end

    it '#run should raise the error once retrying is completed' do
      policy = PolicyBuilder.new do
        retry_times 3
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
    end

    it '#run should call the passed code block 4 times according to fibonacci sequence' do
      policy = PolicyBuilder.new do
        retry_times 3
        with_strategy :fibonacci
        measure_time_in :ms
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
      assert_requested :get, "http://www.example.com", :times => 4
    end

    it '#run should call the passed code block 4 times according to fixed interval strategy' do
      policy = PolicyBuilder.new do
        retry_times 3
        with_strategy :fixed_interval, 2
        measure_time_in :ms
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
      assert_requested :get, "http://www.example.com", :times => 4
    end

    it '#run should call the passed code block 4 times according to exponential backoff sequence' do
      policy = PolicyBuilder.new do
        retry_times 5
        with_strategy :exponential_backoff
        measure_time_in :ms
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
      assert_requested :get, "http://www.example.com", :times => 6
    end

    it '#run does not call the passed code block if exception is not part of allowed exception(s)' do
      @stub = stub_request(:get, "www.example.com").to_raise(RegexpError)
      policy = PolicyBuilder.new do
        retry_times 5
        with_strategy :fibonacci
        only_on_exceptions [ZeroDivisionError]
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
      assert_requested :get, "http://www.example.com", :times => 1
    end

    it '#run should call the passed code block if exception is part of allowed exception(s)' do
      @stub = stub_request(:get, "http://www.example.com").to_raise(ZeroDivisionError)

      policy = PolicyBuilder.new do
        retry_times 10
        with_strategy :fibonacci
        measure_time_in :ms
        only_on_exceptions [ZeroDivisionError, IOError]
      end

      expect do
        Retrier.run(policy) do
          Net::HTTP.get_response(URI.parse("http://www.example.com"))
        end
      end.to raise_error
      assert_requested :get, "http://www.example.com", :times => 11
    end

    it '#run should not raise the error if set to fail silently' do
      policy = PolicyBuilder.new do
        retry_times 3
        fail_silently
      end

      Retrier.run(policy) do
        Net::HTTP.get_response(URI.parse("http://www.example.com"))
      end
    end

  end
end