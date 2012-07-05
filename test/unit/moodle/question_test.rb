require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleQuestion < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @question_category = @course.question_categories.first
    @question = @question_category.questions.first
    @answer = @question.answers.first
    @calculation = @question.calculations.first
    @dataset_definition = @calculation.dataset_definitions.first
    @dataset_item = @dataset_definition.dataset_items.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_an_id
    assert_equal 989, @question.id
  end

  def test_it_has_a_name
    assert_equal 'Basic Arithmetic', @question.name
  end

  def test_it_has_text
    assert_equal 'How much is {a} + {b} ?', @question.text
  end

  def test_it_has_general_feedback
    assert_equal 'This should be easy', @question.general_feedback
  end

  def test_it_has_default_grade
    assert_equal 1, @question.default_grade
  end

  def test_it_has_a_type
    assert_equal 'calculated', @question.type
  end

  def test_it_has_calculations
    assert @question.calculations.length > 0, 'question has no calculations'
  end

  def test_calculation_has_answer_id
    assert_equal 16, @calculation.answer_id
  end

  def test_calculation_has_a_tolerance
    assert_equal 0.01, @calculation.tolerance
  end

  def test_calculation_has_a_correct_answer_length
    assert_equal 2, @calculation.correct_answer_length
  end

  def test_calculation_has_a_correct_answer_format
    assert_equal 1, @calculation.correct_answer_format
  end

  def test_calculation_has_dataset_definitions
    assert @calculation.dataset_definitions.length > 0, 'calculation does not have dataset_definitions'
  end

  def test_dataset_definition_has_a_name
    assert_equal 'a', @dataset_definition.name
  end

  def test_dataset_definition_has_options
    assert_equal 'uniform:1.0:10.0:1', @dataset_definition.options
  end

  def test_dataset_definition_has_dataset_items
    assert @dataset_definition.dataset_items.length > 0, 'dataset_definition does not have dataset_items'
  end

  def test_dataset_item_has_a_number
    assert_equal 1, @dataset_item.number
  end

  def test_dataset_item_has_a_value
    assert_equal 3.0, @dataset_item.value
  end

  def test_it_has_answers
    assert @question.answers.length > 0, 'question does not have answers'
  end

  def test_answer_has_an_id
    assert_equal 16, @answer.id
  end

  def test_answer_has_text
    assert_equal '{a} + {b}', @answer.text
  end

  def test_answer_has_a_fraction
    assert_equal 1.0, @answer.fraction
  end

  def test_answer_has_feedback
    assert_equal 'Great job!', @answer.feedback
  end
end
