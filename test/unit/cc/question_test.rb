require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'test/test_question_helper'
require 'moodle2cc'

class TestUnitCCQuestion < MiniTest::Unit::TestCase
  include TestHelper
  include TestQuestionHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |mod| mod.mod_type == 'quiz' }
    @question = @mod.questions.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @question.id = 989
    question = Moodle2CC::CC::Question.new @question
    assert_equal 989, question.id
  end

  def test_it_converts_title
    @question.name = "Basic Arithmetic"
    question = Moodle2CC::CC::Question.new @question
    assert_equal "Basic Arithmetic", question.title
  end

  def test_it_converts_title_with_escaped_html
    @question.name = "the &lt;div&gt; tag"
    question = Moodle2CC::Canvas::Question.new @question
    assert_equal "the <div> tag", question.title
  end

  def test_it_has_an_identifier_based_on_id
    @question.id = 989
    @question.instance_id = nil
    question = Moodle2CC::CC::Question.new @question
    assert_equal 'i04823ed56ffd4fd5f9c21db0cf25be6c', question.identifier
    # question_989
  end

  def test_it_has_an_identifier_based_on_instance_id
    @question.instance_id = 787
    question = Moodle2CC::CC::Question.new @question
    assert_equal 'i2edcb021d100c968ba3f570253a6aa1c', question.identifier
    # question_instance_787
  end

end
