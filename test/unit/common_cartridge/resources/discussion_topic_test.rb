require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class DiscussionTopicTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @discussion_topic = Moodle2CC::CommonCartridge::Resources::DiscussionTopic.new
  end

  def test_accessors
    assert_accessors(@discussion_topic, :text)
  end
end