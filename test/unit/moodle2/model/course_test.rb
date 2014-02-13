require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'


module Moodle2
  module Model
    class CourseTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @course = Moodle2CC::Moodle2::Model::Course.new
      end

      def teardown
        # Do nothing
      end

      def test_accessors
        assert_accessors(@course, :id_number, :fullname, :shortname, :startdate, :summary, :course_id)
      end
    end
  end
end