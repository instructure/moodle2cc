require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleMod < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @mods = @course.mods
    @quiz_mod = @mods.find { |mod| mod.mod_type == 'quiz' }
    @questionnaire_mod = @mods.find { |mod| mod.mod_type == 'questionnaire' }
    @choice_mod = @mods.find { |mod| mod.mod_type == 'choice' }
    @wiki_mod = @mods.find { |mod| mod.mod_type == 'wiki' }
    @workshop_mod = @mods.find { |mod| mod.mod_type == 'workshop' }
    @question_instance = @quiz_mod.question_instances.first
    @question = @course.question_categories.first.questions.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_all_the_mods
    assert_equal 15, @mods.length
  end

  def test_it_has_an_id
    assert_equal 987, @mods.find{|m| m.id == 987}.id
  end

  def test_it_has_an_var1
    assert_equal 0, @mods.find{|m| m.id == 987}.var1
  end

  def test_it_has_an_var2
    assert_equal 1, @mods.find{|m| m.id == 987}.var2
  end

  def test_it_has_an_var3
    assert_equal 2, @mods.find{|m| m.id == 987}.var3
  end

  def test_it_has_an_var4
    assert_equal 3, @mods.find{|m| m.id == 987}.var4
  end

  def test_it_has_an_var5
    assert_equal 4, @mods.find{|m| m.id == 987}.var5
  end

  def test_it_has_a_mod_type
    assert_equal "assignment", @mods.find{|m| m.id == 987}.mod_type
  end

  def test_it_has_a_type
    assert_equal "file", @mods.find{|m| m.id == 876}.type
  end

  def test_it_has_a_name
    assert_equal "Create a Rails site", @mods.find{|m| m.id == 987}.name
  end

  def test_it_has_a_description
    assert_equal "<h1>Hello World</h1>", @mods.find{|m| m.id == 987}.description
  end

  def test_it_has_a_summary
    assert_equal 'This is my wiki. There are many like it, but this one is mine.', @wiki_mod.summary
  end

  def test_it_has_content
    assert_equal "Section 1", @mods.find{|m| m.id == 654}.content
  end

  def test_it_has_an_assignment_type
    assert_equal "offline", @mods.find{|m| m.id == 987}.assignment_type
  end

  def test_it_has_a_resubmit
    assert_equal false, @mods.find{|m| m.id == 987}.resubmit
  end

  def test_it_has_a_prevent_late
    assert_equal true, @mods.find{|m| m.id == 987}.prevent_late
  end

  def test_it_has_a_grade
    assert_equal 5, @mods.find{|m| m.id == 987}.grade
  end

  def test_it_has_number_of_attachments
    assert_equal 0, @workshop_mod.number_of_attachments
  end

  def test_it_has_number_of_student_assessments
    assert_equal 5, @workshop_mod.number_of_student_assessments
  end

  def test_it_has_anonymous
    assert_equal false, @workshop_mod.anonymous
  end

  def test_it_has_submission_start
    assert_equal 1342117800, @workshop_mod.submission_start
  end

  def test_it_has_submission_end
    assert_equal 1342722600, @workshop_mod.submission_end
  end

  def test_it_has_assessment_start
    assert_equal 1342119000, @workshop_mod.assessment_start
  end

  def test_it_has_assessment_end
    assert_equal 1342724000, @workshop_mod.assessment_end
  end

  def test_it_has_a_time_due
    assert_equal 1355356740, @mods.find{|m| m.id == 987}.time_due
  end

  def test_it_has_a_time_available
    assert_equal 1355314332, @mods.find{|m| m.id == 987}.time_available
  end

  def test_it_has_a_reference
    assert_equal "http://en.wikipedia.org/wiki/Einstein", @mods.find{|m| m.id == 876}.reference
  end

  def test_it_has_an_intro
    assert_equal "General news and announcements", @mods.find{|m| m.id == 765}.intro
  end

  def test_it_has_alltext
    assert_equal "<p><strong> Instructor Resources </strong></p>", @mods.find{|m| m.id == 543}.alltext
  end

  def test_it_has_text
    assert_equal "Which one will you choose?", @choice_mod.text
  end

  def test_it_has_time_open
    assert_equal 1339440600, @quiz_mod.time_open
  end

  def test_it_has_time_close
    assert_equal 1339527000, @quiz_mod.time_close
  end

  def test_it_has_a_time_limit
    assert_equal 45, @quiz_mod.time_limit
  end

  def test_it_has_attempts_number
    assert_equal 2, @quiz_mod.attempts_number
  end

  def test_it_has_a_grade_method
    assert_equal 1, @quiz_mod.grade_method
  end

  def test_it_has_a_password
    assert_equal 'password', @quiz_mod.password
  end

  def test_it_has_a_subnet
    assert_equal '127.0.0.1', @quiz_mod.subnet
  end

  def test_it_has_shuffle_answers
    assert_equal true, @quiz_mod.shuffle_answers
  end

  def test_it_has_a_page_name
    assert_equal 'My Wiki', @wiki_mod.page_name
  end

  def test_it_has_pages
    assert @wiki_mod.pages.length > 0, 'wiki mod does not have pages'
  end

  def test_page_has_a_page_name
    page = @wiki_mod.pages.first
    assert 'My Wiki', page.page_name
  end

  def test_page_has_a_version
    page = @wiki_mod.pages.first
    assert 1, page.version
  end

  def test_page_has_content
    page = @wiki_mod.pages.first
    assert 'This is the content for the first version of the first page', page.content
  end

  def test_it_has_questionnaire_questions
    assert @questionnaire_mod.questions.length > 0, 'questionnaire mod does not have questions'
  end

  def test_questionnaire_questions_are_in_order
    question1 = @questionnaire_mod.questions.first
    assert_equal 'Have you ever been experienced?', question1.content
    assert_equal 1, question1.position
    question2 = @questionnaire_mod.questions.last
    assert_equal 'Are you experienced?', question2.content
    assert_equal 2, question2.position
  end

  def test_it_has_options
    assert @choice_mod.options.length > 0, 'mod does not have options'
  end

  def test_options_have_an_id
    assert_equal 15, @choice_mod.options.first.id
  end

  def test_options_have_text
    assert_equal 'choice1', @choice_mod.options.first.text
  end

  def test_it_has_a_choice_question
    assert_equal 1, @choice_mod.questions.length
  end

  def test_choice_question_has_an_id
    assert_equal "choice_question_110", @choice_mod.questions.first.id
  end

  def test_choice_question_has_a_name
    assert_equal "My Choice", @choice_mod.questions.first.name
  end

  def test_choice_question_has_text
    assert_equal "Which one will you choose?", @choice_mod.questions.first.text
  end

  def test_choice_question_has_a_grade
    assert_equal 1, @choice_mod.questions.first.grade
  end

  def test_choice_question_has_a_type
    assert_equal 'choice', @choice_mod.questions.first.type
  end

  def test_choice_question_has_answers
    assert @choice_mod.questions.first.answers.length > 0, 'choice question does not have answers'
  end

  def test_choice_question_answers_have_an_id
    assert_equal 15, @choice_mod.questions.first.answers.first.id
  end

  def test_choice_question_answers_have_test
    assert_equal 'choice1', @choice_mod.questions.first.answers.first.text
  end

  def test_it_has_question_instances
    assert @quiz_mod.question_instances.length > 0, 'quiz mod does not have question_instances'
  end

  def test_it_has_quiz_questions_from_question_instances
    assert @quiz_mod.questions.length == @quiz_mod.question_instances.length, 'quiz mod does not have questions for each question instance'
    assert_equal @quiz_mod.questions.first.grade, @quiz_mod.question_instances.first.grade
    assert_equal @quiz_mod.questions.first.instance_id, @quiz_mod.question_instances.first.id
  end

  def test_question_instance_has_an_id
    assert_equal 697, @question_instance.id
  end

  def test_question_instance_has_a_question_id
    assert_equal 989, @question_instance.question_id
  end

  def test_question_instance_has_a_grade
    assert_equal 1, @question_instance.grade
  end

  def test_question_instance_has_a_mod
    assert_equal @quiz_mod, @question_instance.mod
  end

  def test_question_instance_has_a_question
    assert_equal @question, @question_instance.question
  end

  def test_it_has_section_mods
    assert_equal @course.sections.first.mods[1], @mods.find{|m| m.id == 987}.section_mod
  end

  def test_it_has_a_grade_item
    mod = @mods.find { |m| m.id == 987 }
    grade_item = @course.grade_items.find { |g| g.item_instance == mod.id }
    assert_equal grade_item, mod.grade_item
  end
end
