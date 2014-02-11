require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model

    class AssignmentTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @assignemnt = Moodle2CC::CanvasCC::Model::Assignment.new
      end

      def test_accessors
        assert_accessors(@assignemnt, :body, :meta_fields)
      end

    end
  end
end
