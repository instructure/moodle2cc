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

  def test_it_converts_material
    @question.text = "How much is {a} + {b} ?"
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal "How much is [a] + [b] ?", question.material
  end

  def test_it_converts_general_feedback
    @question.general_feedback = "This should be easy"
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal "This should be easy", question.general_feedback
  end

  def test_it_converts_answer_tolerance
    @question.calculations.first.tolerance = 0.01
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 0.01, question.answer_tolerance
  end

  def test_it_converts_formula_decimal_places
    calculation = @question.calculations.first
    calculation.correct_answer_format = 1 # decimal
    calculation.correct_answer_length = 2

    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 2, question.formula_decimal_places

    calculation.correct_answer_format = 2 # significant figures

    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 0, question.formula_decimal_places
  end

  def test_it_converts_formulas
    answer1 = @question.answers.first
    answer2 = answer1.dup
    @question.answers << answer2

    answer1.text = '{a} + {b}'
    answer2.text = '{a} * {b}'

    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 2, question.formulas.length
    assert_equal 'a+b', question.formulas.first
    assert_equal 'a*b', question.formulas.last
  end

  def test_it_converts_vars
    calculation = @question.calculations.first
    ds_def1 = calculation.dataset_definitions.first
    ds_def2 = calculation.dataset_definitions.last

    ds_def1.name = 'a'
    ds_def1.options = 'uniform:3.0:9.0:3'

    ds_def2.name = 'b'
    ds_def2.options = 'uniform:1.0:10.0:1'

    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 2, question.vars.length
    assert_equal({:name => 'a', :scale => '3', :min => '3.0', :max => '9.0'}, question.vars.first)
    assert_equal({:name => 'b', :scale => '1', :min => '1.0', :max => '10.0'}, question.vars.last)
  end

  def test_it_converts_var_sets
    calculation = @question.calculations.first
    ds_def1 = calculation.dataset_definitions.first
    ds_def2 = calculation.dataset_definitions.last

    ds_def1.name = 'a'
    ds_item1 = ds_def1.dataset_items.first
    ds_item2 = ds_item1.dup
    ds_def1.dataset_items[1] = ds_item2

    ds_item1.number = 1
    ds_item1.value = 3.0
    ds_item2.number = 2
    ds_item2.value = 5.5

    ds_def2.name = 'b'
    ds_item1 = ds_def2.dataset_items.first
    ds_item2 = ds_item1.dup
    ds_def2.dataset_items[1] = ds_item2

    ds_item1.number = 1
    ds_item1.value = 6.0
    ds_item2.number = 2
    ds_item2.value = 1.0

    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 2, question.var_sets.length
    assert_equal({:vars => {'a' => 3.0, 'b' => 6.0}, :answer => 9.0}, question.var_sets.first)
    assert_equal({:vars => {'a' => 5.5, 'b' => 1.0}, :answer => 6.5}, question.var_sets.last)
  end

  def test_it_has_an_identifier
    @question.id = 989
    question = Moodle2CC::CC::Question.new @question_instance
    assert_equal 'i04823ed56ffd4fd5f9c21db0cf25be6c', question.identifier
    # question_989
  end

  def test_it_creates_item_xml
    question = Moodle2CC::CC::Question.new @question_instance
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(question.create_item_xml(node))

    assert xml.root
    assert_equal 'item', xml.root.name
    assert_equal 'Basic Arithmetic', xml.root.attributes['title'].value
    assert_equal 'i04823ed56ffd4fd5f9c21db0cf25be6c', xml.root.attributes['ident'].value

    assert xml.root.xpath('itemmetadata/qtimetadata/qtimetadatafield[fieldlabel="question_type" and fieldentry="calculated_question"]').first, 'does not have meta data for question type'
    assert xml.root.xpath('itemmetadata/qtimetadata/qtimetadatafield[fieldlabel="points_possible" and fieldentry="1"]').first, 'does not have meta data for points possible'
    # assert xml.root.xpath('itemmetadata/qtimetadata/qtimetadatafield[fieldlabel="assessment_question_identifierref" and fieldentry="1"]').first, 'does not have meta data for assessment_question_identifierref'

    assert_equal 'How much is [a] + [b] ?', xml.root.xpath('presentation/material/mattext[@texttype="text/html"]').text

    # Score
    outcome = xml.root.xpath('resprocessing/outcomes/decvar').first
    assert_equal '100', outcome.attributes['maxvalue'].value
    assert_equal '0', outcome.attributes['minvalue'].value
    assert_equal 'SCORE', outcome.attributes['varname'].value
    assert_equal 'Decimal', outcome.attributes['vartype'].value

    # General Feedback
    general_feedback = xml.root.xpath('resprocessing/respcondition[1]').first
    assert_equal 'Yes', general_feedback.attributes['continue'].value
    assert general_feedback.xpath('conditionvar/other').first, 'does not contain conditionvar'
    assert_equal 'Response', general_feedback.xpath('displayfeedback').first.attributes['feedbacktype'].value
    assert_equal 'general_fb', general_feedback.xpath('displayfeedback').first.attributes['linkrefid'].value

    general_feedback = xml.root.xpath('itemfeedback[@ident="general_fb"]').first
    assert general_feedback, 'no feeback node'
    material = general_feedback.xpath('flow_mat/material/mattext[@texttype="text/plain"]').first
    assert material, 'no feedback text'
    assert_equal 'This should be easy', material.text
  end

  def test_it_creates_item_xml_for_calculated_question
    @question.type = 'calculated'
    question = Moodle2CC::CC::Question.new @question_instance
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(question.create_item_xml(node))

    response = xml.root.xpath('presentation/response_str').first
    assert_equal 'Single', response.attributes['rcardinality'].value
    assert_equal 'response1', response.attributes['ident'].value
    assert_equal 'Decimal', response.xpath('render_fib').first.attributes['fibtype'].value
    assert_equal 'answer1', response.xpath('render_fib/response_label').first.attributes['ident'].value

    # Correct Condition
    condition = xml.root.xpath('resprocessing/respcondition[@title="correct"]').first
    assert condition, 'correct condition node does not exist'
    assert condition.xpath('conditionvar/other').first, 'conditionvar does not exist for correct condition node'
    setvar = condition.xpath('setvar').first
    assert setvar, 'setvar does not exist for correct condition node'
    assert_equal 'SCORE', setvar.attributes['varname'].value
    assert_equal 'Set', setvar.attributes['action'].value
    assert_equal '100', setvar.text

    # Incorrect Condition
    condition = xml.root.xpath('resprocessing/respcondition[@title="incorrect"]').first
    assert condition, 'incorrect condition node does not exist'
    assert condition.xpath('conditionvar/other').first, 'conditionvar does not exist for incorrect condition node'
    setvar = condition.xpath('setvar').first
    assert setvar, 'setvar does not exist for incorrect condition node'
    assert_equal 'SCORE', setvar.attributes['varname'].value
    assert_equal 'Set', setvar.attributes['action'].value
    assert_equal '0', setvar.text

    # Calculations
    calculated = xml.root.xpath('itemproc_extension/calculated').first
    assert calculated, 'calculated node does not exist'
    assert_equal '0.01', calculated.xpath('answer_tolerance').text

    # Formulas
    assert calculated.xpath('formulas[@decimal_places="2"]').first, 'calculated node does not contain formulas with decimal_places'
    assert calculated.xpath('formulas/formula["a+b"]').first, 'calculated node does not contain the formula a+b'

    # Var
    a_var = calculated.xpath('vars/var[@scale="1"][@name="a"]').first
    assert a_var, 'calculated node does not have variable for a'
    assert_equal '1.0', a_var.xpath('min').text
    assert_equal '10.0', a_var.xpath('max').text
    b_var = calculated.xpath('vars/var[@scale="1"][@name="b"]').first
    assert b_var, 'calculated node does not have variable for b'
    assert_equal '1.0', b_var.xpath('min').text
    assert_equal '10.0', b_var.xpath('max').text

    # Var Sets
    var_set1 = calculated.xpath('var_sets/var_set[1]').first
    assert var_set1, 'first var_set does not exist'
    assert_equal '3060', var_set1.attributes['ident'].value
    assert var_set1.xpath('var[@name="a"][3.0]'), 'first var_set does not have a value for a'
    assert var_set1.xpath('var[@name="b"][6.0]'), 'first var_set does not have a value for b'
    assert var_set1.xpath('answer[9.0]'), 'first var_set does not have an answer'

    var_set2 = calculated.xpath('var_sets/var_set[2]').first
    assert var_set2, 'second var_set does not exist'
    assert_equal '5510', var_set2.attributes['ident'].value
    assert var_set2.xpath('var[@name="a"][5.5]'), 'second var_set does not have a value for a'
    assert var_set2.xpath('var[@name="b"][1.0]'), 'second var_set does not have a value for b'
    assert var_set2.xpath('answer[6.5]'), 'second var_set does not have an answer'
  end
end
