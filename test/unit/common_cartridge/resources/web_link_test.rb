require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class WebLinkTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @web_link = Moodle2CC::CommonCartridge::Resources::WebLink.new
  end

  def test_accessors
    assert_accessors(@web_link, :url, :external_link, :href)
  end

end