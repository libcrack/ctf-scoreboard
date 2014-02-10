require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class SolveTest < Test::Unit::TestCase
  context "Solve Model" do
    should 'construct new instance' do
      @solve = Solve.new
      assert_not_nil @solve
    end
  end
end
