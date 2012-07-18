require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCResource < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @cc_factory = Moodle2CC::ResourceFactory.new Moodle2CC::CC
    @canvas_factory = Moodle2CC::ResourceFactory.new Moodle2CC::Canvas
    convert_moodle_backup
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_can_get_assessment_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "quiz" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assessment, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Assessment, resource
  end

  def test_it_can_get_assignment_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "assignment" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assignment, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Assignment, resource
  end

  def test_it_can_get_discussion_topic_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "forum" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::DiscussionTopic, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::DiscussionTopic, resource
  end

  def test_it_can_get_web_content_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "resource" }
    mod.type = 'html'
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_web_link_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "resource" }
    mod.type = 'file'
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebLink, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebLink, resource
  end

  def test_it_can_get_wiki_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "wiki" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Wiki, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Wiki, resource
  end

  def test_it_can_get_label_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Label, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Label, resource
  end

  def test_it_can_get_web_content_resource_from_label_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(<img src="http://image.com/image.jpg" />")
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_assessment_resource_from_questionnaire_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "questionnaire" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assessment, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Assessment, resource
  end

  def test_it_can_get_assessment_resource_from_choice_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "choice" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assessment, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Assessment, resource
  end

  def test_it_can_get_assignment_resource_from_workshop_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "workshop" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assignment, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Assignment, resource
  end
end
