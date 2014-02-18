require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  class ExtractorTest < MiniTest::Unit::TestCase
    include TestHelper

    # Do nothing
    def setup
      @extractor = Moodle2CC::Moodle2::Extractor.new('path_to_zip')
    end

    # Do nothing
    def teardown

    end

    def test_course_parsing
      course = Moodle2CC::Moodle2::Model::Course.new
      course.id_number = 'id_number'

      course_converter_mock = MiniTest::Mock.new
      course_converter_mock.expect(:parse, course)

      Moodle2CC::Moodle2::CourseParser.stub(:new, course_converter_mock) do
        @extractor.stub(:extract_zip, nil) do
          extracted_course = @extractor.extract
          assert_equal(extracted_course.id_number, 'id_number')
        end
      end

    end

  end
end