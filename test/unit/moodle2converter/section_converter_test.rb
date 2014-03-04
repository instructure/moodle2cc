require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2Converter
  class SectionConverterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @section_converter = Moodle2CC::Moodle2Converter::SectionConverter.new
    end

    def teardown
      # Do nothing
    end

    def test_conversion
      moodle_section = Moodle2CC::Moodle2::Model::Section.new
      moodle_section.id = 'section_id'
      moodle_section.name = 'section_name'
      moodle_section.visible = false
      moodle_section.position = 1
      canvas_module = @section_converter.convert(moodle_section)
      assert_equal('module_730f6511535a1e4cf13e886e52b21dc9', canvas_module.identifier)
      assert_equal(canvas_module.title, 'section_name')
      assert_equal(canvas_module.workflow_state, 'unpublished')
      assert_equal(canvas_module.position, 1)
    end

  end
end