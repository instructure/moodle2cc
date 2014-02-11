require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model
    class DiscussionTopicTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @discussion_topic = Moodle2CC::CanvasCC::Model::DiscussionTopic.new
      end

      def test_accessors
        assert_accessors(@discussion_topic, :text)
      end
    end
  end
end
