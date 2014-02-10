require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class ResponseTest < Test::Unit::TestCase
  context "Response Model" do
    should 'construct new instance' do
      @response = Response.new
      assert_not_nil @response
    end
  end
end
