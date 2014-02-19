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
        assert_accessors(@course, :format, :title, :copyright)
        assert_equal(@course.resources.class, Array)
        assert_equal(@course.canvas_modules.class, Array)
      end

      def test_identifier
        @course.identifier = '4321_ident'
        assert_equal('CC_e8b5470638aa6d420713986cdd7ce3a3', @course.identifier)
      end

      def test_settings
        @course.title = 'course_title'
        assert_equal('course_title', @course.settings[:title])
      end

      def test_date_string
        #Moodle2CC::CC::CCHelper.ims_datetime
        @course.start_at = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
        @course.conclude_at = Time.parse('Sat, 10 Feb 2014 16:00:00 GMT')
        assert_equal('2014-02-08T16:00:00', @course.start_at)
        assert_equal('2014-02-10T16:00:00', @course.conclude_at)
      end

    end
  end
end

