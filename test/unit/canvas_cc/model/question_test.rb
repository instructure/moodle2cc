require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model

    class QuestionTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @question = Moodle2CC::CanvasCC::Model::Question.new
      end

      def test_accessors
        assert_accessors(@question, :id, :title, :identifier)
      end

    end
  end
end
