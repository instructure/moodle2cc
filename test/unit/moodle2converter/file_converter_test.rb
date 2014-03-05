require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class FileConverterTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @file_converter = Moodle2CC::Moodle2Converter::FileConverter.new
  end

  def teardown
    # Do nothing
  end


  def test_conversion
    moodle_file = Moodle2CC::Moodle2::Models::Moodle2File.new
    moodle_file.file_location = 'path_to_file'
    moodle_file.file_name = 'my_file_name'
    moodle_file.id = 'my_file_id'
    canvas_file = @file_converter.convert(moodle_file)
    assert_equal('CC_4087b826b314cdf5502177830f7f11ac_FILE', canvas_file.identifier)
    assert_equal('path_to_file', canvas_file.file_location)
    assert_equal('my_file_name', canvas_file.file_path)
  end
end