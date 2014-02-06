require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class CourseTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @course = Moodle2CC::CommonCartridge::Resources::Course.new
  end

  def test_accessors
    assert_accessors(@course, :format, :identifier, :title, :copyright)
  end

end

