require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasQuestionBank < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup 'canvas'
    @course = @backup.course
    @question_category = @course.question_categories.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @question_category.id = 121
    question_bank = Moodle2CC::Canvas::QuestionBank.new @question_category
    assert_equal 121, question_bank.id
  end

  def test_it_converts_title
    @question_category.name = 'Default for Beginning Ruby on Rails'
    question_bank = Moodle2CC::Canvas::QuestionBank.new @question_category
    assert_equal 'Default for Beginning Ruby on Rails', question_bank.title
  end

  def test_it_converts_questions
    question_bank = Moodle2CC::Canvas::QuestionBank.new @question_category
    assert_equal 5, question_bank.questions.length
    assert_kind_of Moodle2CC::Canvas::Question, question_bank.questions[0]
    assert_kind_of Moodle2CC::Canvas::Question, question_bank.questions[1]
    assert_kind_of Moodle2CC::Canvas::Question, question_bank.questions[2]
    assert_kind_of Moodle2CC::Canvas::Question, question_bank.questions[3]
    assert_kind_of Moodle2CC::Canvas::Question, question_bank.questions[4]
  end

  def test_it_does_not_convert_random_questions
    convert_moodle_backup('canvas', 'moodle_backup_random_questions')
    mod = @backup.course.mods.find { |m| m.mod_type == "quiz" }
    question_category = @backup.course.question_categories.first
    question_bank = Moodle2CC::Canvas::QuestionBank.new question_category

    assert_equal 2, question_bank.questions.length
  end

  def test_it_has_an_identifier
    @question_category.id = 121
    question_bank = Moodle2CC::Canvas::QuestionBank.new @question_category
    # objectbank_{id}
    assert_equal 'i02849cd800255cc6c762cdafd8d8db67', question_bank.identifier
  end

  def test_it_creates_resource_in_imsmanifest
    question_bank = Moodle2CC::Canvas::QuestionBank.new @question_category
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(question_bank.create_resource_node(node))

    resource = xml.xpath('resource').first
    assert resource
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'non_cc_assessments/i02849cd800255cc6c762cdafd8d8db67.xml.qti', resource.attributes['href'].value
    assert_equal 'i02849cd800255cc6c762cdafd8d8db67', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="non_cc_assessments/i02849cd800255cc6c762cdafd8d8db67.xml.qti"]').first
    assert file
  end

  def test_it_creates_qti_xml
    question_bank = Moodle2CC::Canvas::QuestionBank.new @question_category
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    question_bank.create_qti_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, 'non_cc_assessments', "i02849cd800255cc6c762cdafd8d8db67.xml.qti")))

    assert xml
    assert_equal "http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://www.imsglobal.org/xsd/ims_qtiasiv1p2", xml.namespaces['xmlns']
    assert_equal 'questestinterop', xml.root.name

    assert_equal 'i02849cd800255cc6c762cdafd8d8db67', xml.root.xpath('xmlns:objectbank').first.attributes['ident'].value

    time_data = xml.root.xpath('xmlns:objectbank/xmlns:qtimetadata/xmlns:qtimetadatafield[xmlns:fieldlabel="bank_title" and xmlns:fieldentry="Default for Beginning Ruby on Rails"]').first
    assert time_data, 'qtimetadata does not exist for time limit'

    items = xml.root.xpath('xmlns:objectbank/xmlns:item')
    assert_equal 5, items.length
  end
end
