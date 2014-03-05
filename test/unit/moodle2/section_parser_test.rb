require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  class SectionParserTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @section_parser = Moodle2CC::Moodle2::Parser::SectionParser.new(fixture_path(File.join('moodle2', 'backup')))
    end

    def teardown
      # Do nothing
    end

    def test_create_section
      sections = @section_parser.parse
      assert_equal(7, sections.count)
      section = sections.first
      assert_equal( 0, section.position)
      assert_equal( '0', section.number)
      assert_nil(section.name)
      assert_equal('<p>This is the General Summary</p>', section.summary)
      assert_equal( '1', section.summary_format)
      assert_equal( '1', section.sequence)
      assert_equal( true, section.visible)
      assert_equal( '0', section.available_from)
      assert_equal( '0', section.available_until)
      assert_equal( '0', section.show_availability)
      assert_equal( '0', section.grouping_id)
      assert_equal(3, sections[3].position)
      assert_equal(false, sections[1].visible)
    end
  end
end