require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCQuestion < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |mod| mod.mod_type == 'quiz' }
    @question_instance = @mod.question_instances.first
    @question = @question_instance.question
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @question.id = 989
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 989, question.id
  end

  def test_it_converts_title
    @question.name = "Basic Arithmetic"
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal "Basic Arithmetic", question.title
  end

  def test_it_converts_question_type
    @question.type = 'calculated'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'calculated_question', question.question_type

    @question.type = 'description'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'text_only_question', question.question_type

    @question.type = 'essay'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'essay_question', question.question_type

    @question.type = 'match'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'matching_question', question.question_type

    @question.type = 'multianswer'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'multiple_answers_question', question.question_type

    @question.type = 'multichoice'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'multiple_choice_question', question.question_type

    @question.type = 'shortanswer'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'short_answer_question', question.question_type

    @question.type = 'numerical'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'numerical_question', question.question_type

    @question.type = 'truefalse'
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'true_false_question', question.question_type
  end

  def test_it_converts_points_possible
    @question_instance.grade = 5
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 5, question.points_possible
  end
end
