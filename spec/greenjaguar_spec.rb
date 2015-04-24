require 'spec_helper'

describe Greenjaguar do
  before do
    @stub = stub_request(:get, "http://www.example.com").to_raise("some error")
  end

  after do
    WebMock.reset!
  end

  it '#run should call the passed code block 4 times' do
    policy = Greenjaguar::PolicyBuilder.new do
      retry_times(3)
    end

    expect do
      Greenjaguar::Retrier.run(policy) do
        Net::HTTP.get_response(URI.parse("http://www.example.com"))
      end
    end.to raise_error
    assert_requested :get, "http://www.example.com", :times => 4
  end

  it '#run should call the passed code block only 1 time if successful response is received' do
    @stub = stub_request(:get, "www.example.com")

    policy = Greenjaguar::PolicyBuilder.new do
      retry_times(3)
    end

    Greenjaguar::Retrier.run(policy) do
      Net::HTTP.get_response(URI.parse("http://www.example.com"))
    end
    assert_requested :get, "http://www.example.com", :times => 1
  end

  it '#run should raise the error once retrying is completed' do
    policy = Greenjaguar::PolicyBuilder.new do
      retry_times(3)
    end

    expect do
      Greenjaguar::Retrier.run(policy) do
        Net::HTTP.get_response(URI.parse("http://www.example.com"))
      end
    end.to raise_error
  end

  it '#run should call the passed code block 4 times according to fibonacci sequence' do
    policy = Greenjaguar::PolicyBuilder.new do
      retry_times(3).with_strategy(:fibonacci)
    end

    expect do
      Greenjaguar::Retrier.run(policy) do
        Net::HTTP.get_response(URI.parse("http://www.example.com"))
      end
    end.to raise_error
    assert_requested :get, "http://www.example.com", :times => 4
  end
end