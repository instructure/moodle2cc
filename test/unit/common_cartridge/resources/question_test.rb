require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class QuestionTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @question = Moodle2CC::CommonCartridge::Resources::Question.new
  end

  def test_accessors
    assert_accessors(@question, :id, :title, :identifier)
  end

end