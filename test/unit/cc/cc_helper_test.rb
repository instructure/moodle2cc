require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCCCHelper < MiniTest::Unit::TestCase
  include TestHelper

  def test_it_creates_valid_file_names
    assert_equal 'psy101-isnt-this-a-cool-course', Moodle2CC::CC::CCHelper.file_slug("PSY101 Isn't this a cool course?")
  end
end
