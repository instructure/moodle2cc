require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model
    class CourseTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @course = Moodle2CC::CanvasCC::Model::Course.new
      end

      def test_accessors
        assert_accessors(@course, :format, :identifier, :title, :copyright)
        assert_equal(@course.resources.class, Array)
      end

      def test_settings
        @course.title = 'course_title'
        assert_equal('course_title', @course.settings[:title])
      end

    end
  end
end

