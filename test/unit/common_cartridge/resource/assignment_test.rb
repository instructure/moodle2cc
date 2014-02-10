require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class AssignmentTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @assignemnt = Moodle2CC::CommonCartridge::Resource::Assignment.new
  end

  def test_accessors
    assert_accessors(@assignemnt, :body, :meta_fields)
  end

end