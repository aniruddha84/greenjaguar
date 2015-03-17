require 'spec_helper'

describe Greenjaguar do
  before do
    @stub = stub_request(:get, "www.example.com").to_raise("some error")
  end

  after do
    WebMock.reset!
  end

  it '#run should call the passed code block 4 times' do
    Greenjaguar::Retrier.run(3) do
      Net::HTTP.get_response(URI.parse("http://www.example.com"))
    end
    assert_requested :get, "http://www.example.com", :times => 4
  end

  it '#run should call the passed code block only 1 time if the successful response is received' do
    @stub = stub_request(:get, "www.example.com")
    Greenjaguar::Retrier.run(3) do
      Net::HTTP.get_response(URI.parse("http://www.example.com"))
    end
    assert_requested :get, "http://www.example.com", :times => 1
  end
end