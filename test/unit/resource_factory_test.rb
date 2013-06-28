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

    mod = @backup.course.mods.find { |m| m.mod_type == "hsuforum" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::DiscussionTopic, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::DiscussionTopic, resource
  end

  def test_it_can_get_web_content_resource_from_text_resource
    mod = @backup.course.mods.find { |m| m.mod_type == "resource" }
    mod.type = 'text'
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_web_content_resource_from_html_resource
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

  def test_it_can_get_label_resource_from_summary_mod
    mod = @backup.course.mods.find { |m| m.mod_type == "summary" }
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Label, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Label, resource
  end

  def test_it_can_get_web_content_resource_from_label_mod_with_img_tag
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(<img src="http://image.com/image.jpg" />")
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_web_content_resource_from_label_mod_with_an_a_tag
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(<a href="http://www.google.com">Google</a>")
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_label_resource_from_label_mod_with_an_a_tag_with_no_href
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(<a name="Google">Google</a>")
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Label, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Label, resource
  end

  def test_it_can_get_web_content_resource_from_label_mod_with_an_iframe
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(<iframe src="http://www.google.com"></iframe>)
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_web_content_resource_from_label_mod_with_a_lot_of_text
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.content = %(
      <p>
        I will always test my code,
        I will always test my code,
        I will always test my code
      </p>)
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::WebContent, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::WebContent, resource
  end

  def test_it_can_get_label_resource_from_label_mod_with_minimal_html
    mod = @backup.course.mods.find { |m| m.mod_type == "label" }
    mod.name = "Forum"
    mod.content = %(
      <h4 style="color: rgb(0, 0, 153); margin-left: 40px; font-weight: normal; ">
        <font size="3">
          <a name="Anker1"> Forum</a>
        </font>
      </h4>)
    resource = @cc_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::CC::Label, resource

    resource = @canvas_factory.get_resource_from_mod(mod)
    assert_kind_of Moodle2CC::Canvas::Label, resource
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
