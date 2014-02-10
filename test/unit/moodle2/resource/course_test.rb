require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'


class CourseTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @course = Moodle2CC::Moodle2::Resource::Course.new
  end

  def teardown
    # Do nothing
  end

  def test_accessors
    assert_accessors(@course, :id_number, :fullname, :shortname, :startdate, :summary)
  end
end