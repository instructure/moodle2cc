require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCResource < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_can_get_assessment_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "quiz" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assessment, resource
  end

  def test_it_can_get_assignment_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "assignment" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assignment, resource
  end

  def test_it_can_get_discussion_topic_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "forum" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::DiscussionTopic, resource
  end

  def test_it_can_get_web_content_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "resource" }
    mod.type = 'html'
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource
  end

  def test_it_can_get_web_link_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "resource" }
    mod.type = 'file'
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebLink, resource
  end

  def test_it_can_get_wiki_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "wiki" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Wiki, resource
  end

  def test_it_can_get_label_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Label, resource
  end

  def test_it_can_get_web_content_resource_from_label_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(<img src="http://image.com/image.jpg" />")
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource
  end

  def test_it_can_get_assessment_resource_from_questionnaire_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "questionnaire" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assessment, resource
  end

  def test_it_can_get_assessment_resource_from_choice_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "choice" }
    resource = Moodle2CC::CC::Resource.get_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Assessment, resource
  end
end
