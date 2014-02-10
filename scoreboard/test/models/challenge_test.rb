require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class ChallengeTest < Test::Unit::TestCase
  context "Challenge Model" do
    should 'construct new instance' do
      @challenge = Challenge.new
      assert_not_nil @challenge
    end
  end
end
