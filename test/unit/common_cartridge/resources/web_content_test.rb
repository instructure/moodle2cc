require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class WebContentTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @web_content = Moodle2CC::CommonCartridge::Resources::WebContent.new
  end

  def test_accessors
    assert_accessors(@web_content, :body)
  end

end