require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleQuestion < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @questionnaire_mod = @course.mods.find { |mod| mod.mod_type == 'questionnaire' }
    @question_category = @course.question_categories.first

    @calculated_question = @question_category.questions.find { |q| q.type == 'calculated' }
    @match_question = @question_category.questions.find { |q| q.type == 'match' }
    @numerical_question = @question_category.questions.find { |q| q.type == 'numerical' }
    @questionnaire_question = @questionnaire_mod.questions.last

    @answer = @calculated_question.answers.first
    @calculation = @calculated_question.calculations.first
    @dataset_definition = @calculation.dataset_definitions.first
    @dataset_item = @dataset_definition.dataset_items.first

    @match = @match_question.matches.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_an_id
    assert_equal 989, @calculated_question.id
  end

  def test_it_has_a_name
    assert_equal 'Basic Arithmetic', @calculated_question.name
  end

  def test_it_has_text
    assert_equal 'How much is {a} + {b} ?', @calculated_question.text
  end

  def test_it_has_a_format
    assert_equal 1, @calculated_question.format
  end

  def test_it_has_general_feedback
    assert_equal 'This should be easy', @calculated_question.general_feedback
  end

  def test_it_has_default_grade
    assert_equal 1, @calculated_question.default_grade
  end

  def test_it_has_a_type
    assert_equal 'calculated', @calculated_question.type
  end

  def test_it_has_a_position
    assert_equal 2, @questionnaire_question.position
  end

  def test_it_has_length
    assert_equal 1, @calculated_question.length
  end

  def test_it_has_a_type_id
    assert_equal 5, @questionnaire_question.type_id
  end

  def test_it_has_content
    assert_equal 'Are you experienced?', @questionnaire_question.content
  end

  def test_it_has_question_choices
    assert @questionnaire_question.choices.length > 0, 'questionnaire question has no choices'
  end

  def test_choice_has_an_id
    assert_equal 1, @questionnaire_question.choices.first.id
  end

  def test_choice_has_content
    assert_equal 'Yes', @questionnaire_question.choices.first.content
  end

  def test_it_has_calculations
    assert @calculated_question.calculations.length > 0, 'question has no calculations'
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

  def test_it_has_numericals
    assert @numerical_question.numericals.length > 0, 'question does not have numericals'
  end

  def test_numericals_has_an_answer_id
    assert_equal 43, @numerical_question.numericals.first.answer_id
  end

  def test_numericals_has_a_tolerance
    assert_equal 2, @numerical_question.numericals.first.tolerance
  end

  def test_it_has_answers
    assert @calculated_question.answers.length > 0, 'question does not have answers'
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

  def test_it_has_matches
    assert @match_question.matches.length > 0, 'question does not have matches'
  end

  def test_match_has_an_id
    assert_equal 7, @match.id
  end

  def test_match_has_a_code
    assert_equal 400458432, @match.code
  end

  def test_match_has_question_text
    assert_equal 'Ruby on Rails is written in this language', @match.question_text
  end

  def test_match_has_answer_text
    assert_equal 'Ruby', @match.answer_text
  end

  def test_it_has_an_instance
    quiz_mod = @course.mods.find { |mod| mod.mod_type == 'quiz' }
    instance = quiz_mod.question_instances.find { |i| i.question_id == @calculated_question.id }
    assert_equal instance, @calculated_question.instance
  end
end
