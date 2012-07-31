require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasQuestionGroup < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup 'canvas', 'moodle_backup_random_questions'
    @course = @backup.course
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_an_id
    question_group = Moodle2CC::Canvas::QuestionGroup.new :id => 1
    assert_equal 1, question_group.id
  end

  def test_it_has_an_id_that_defaults_to_1
    question_group = Moodle2CC::Canvas::QuestionGroup.new
    assert_equal 1, question_group.id
  end

  def test_it_has_a_title_from_the_id
    question_group = Moodle2CC::Canvas::QuestionGroup.new :id => 1
    assert_equal 'Group 1', question_group.title
  end

  def test_it_has_a_selection_number
    question_group = Moodle2CC::Canvas::QuestionGroup.new
    assert_equal 1, question_group.selection_number
  end

  def test_it_can_increment_the_selection_number
    question_group = Moodle2CC::Canvas::QuestionGroup.new
    question_group.increment_selection_number
    assert_equal 2, question_group.selection_number
  end

  def test_it_has_points_per_item
    question_group = Moodle2CC::Canvas::QuestionGroup.new :points_per_item => 2
    assert_equal 2, question_group.points_per_item
  end

  def test_it_has_points_per_item_that_defaults_to_1
    question_group = Moodle2CC::Canvas::QuestionGroup.new
    assert_equal 1, question_group.points_per_item
  end

  def test_it_has_a_question_bank
    question_category = @course.question_categories.first
    question_bank = Moodle2CC::Canvas::QuestionBank.new question_category
    question_group = Moodle2CC::Canvas::QuestionGroup.new :question_bank => question_bank
    assert_equal question_bank, question_group.question_bank
  end

  def test_it_has_a_sourcebank_ref
    question_category = @course.question_categories.first
    question_bank = Moodle2CC::Canvas::QuestionBank.new question_category
    question_group = Moodle2CC::Canvas::QuestionGroup.new :question_bank => question_bank
    assert_equal question_bank.identifier, question_group.sourcebank_ref
  end

  def test_it_has_an_identifer_based_on_id
    question_group = Moodle2CC::Canvas::QuestionGroup.new :id => 1
    assert_equal 'i5432a6c714ced15aecdc0209411ecbe9', question_group.identifier
    # question_group_1
  end

  def test_it_creates_item_xml
    mod = @course.mods.find { |mod| mod.mod_type == 'quiz' }
    assessment = Moodle2CC::Canvas::Assessment.new mod
    question_group = assessment.questions.first
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(question_group.create_item_xml(node))

    assert xml.root, 'root element does not exist'
    assert_equal 'section', xml.root.name
    assert_equal 'Group 1', xml.root.attributes['title'].value
    assert_equal 'i5432a6c714ced15aecdc0209411ecbe9', xml.root.attributes['ident'].value

    assert_equal question_group.sourcebank_ref, xml.root.xpath('selection_ordering/selection/sourcebank_ref').text
    assert_equal '2', xml.root.xpath('selection_ordering/selection/selection_number').text
    assert_equal '1', xml.root.xpath('selection_ordering/selection/selection_extension/points_per_item').text
  end
end
