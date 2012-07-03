require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleQuestionCategory < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @question_category = @course.question_categories.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_an_id
    assert_equal 121, @question_category.id
  end

  def test_it_has_a_name
    assert_equal 'Default for Beginning Ruby on Rails', @question_category.name
  end

  def test_it_has_info
    assert_equal "The default category for questions shared in context 'Beginning Ruby on Rails'.", @question_category.info
  end

  def test_it_has_questions
    assert @question_category.questions.length > 0, 'question_category has no questions'
  end
end
