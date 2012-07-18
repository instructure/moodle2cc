require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCAssessment < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |m| m.mod_type == "quiz" }
    @assessment = Moodle2CC::CC::Assessment.new @mod
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 321
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 321, assessment.id
  end

  def test_it_converts_title
    @mod.name = "First Quiz"
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal "First Quiz", assessment.title
  end

  def test_it_has_an_identifier
    @mod.id = 321
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'i058d7533a77712b6e7757b34e66df7fc', assessment.identifier
  end

  def test_it_creates_resource_in_imsmanifest
    node = Builder::XmlMarkup.new
    xml = node.root do |root_node|
      @assessment.create_resource_node(node)
    end
    xml = Nokogiri::XML(xml)

    resource = xml.root.xpath('resource[@type="imsqti_xmlv1p2/imscc_xmlv1p1/assessment"]').first
    assert resource, 'assessment resource does not exist for assessment'
    assert_equal 'i058d7533a77712b6e7757b34e66df7fc', resource.attributes['identifier'].value
  end
end
