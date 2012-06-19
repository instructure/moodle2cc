require 'minitest/autorun'
require 'moodle2cc'

class TestUnitCCItem < MiniTest::Unit::TestCase
  def setup
    xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<MOODLE_BACKUP>
  <INFO>
    <NAME>moodle_backup.zip</NAME>
    <DETAILS>
      <MOD>
        <NAME>assignment</NAME>
        <INCLUDED>true</INCLUDED>
        <USERINFO>true</USERINFO>
        <INSTANCES>
          <INSTANCE>
          <ID>987</ID>
          <NAME>Create a Rails site</NAME>
          <INCLUDED>true</INCLUDED>
          <USERINFO>true</USERINFO>
          </INSTANCE>
        </INSTANCES>
      </MOD>
    </DETAILS>
  </INFO>
  <COURSE>
    <HEADER>
      <ID>55555</ID>
      <FULLNAME>My Course</FULLNAME>
      <SHORTNAME>EDU 101</SHORTNAME>
    </HEADER>
    <SECTIONS>
      <SECTION>
        <ID>12345</ID>
        <NUMBER>0</NUMBER>
        <SUMMARY>&lt;h1&gt;Week 0 Summary&lt;/h1&gt;</SUMMARY>
        <VISIBLE>1</VISIBLE>
        <MODS>
          <MOD>
            <ID>11111</ID>
            <TYPE>assignment</TYPE>
            <INSTANCE>987</INSTANCE>
            <ADDED>1338410699</ADDED>
            <SCORE>0</SCORE>
            <INDENT>0</INDENT>
            <VISIBLE>1</VISIBLE>
            <GROUPMODE>0</GROUPMODE>
            <GROUPINGID>0</GROUPINGID>
            <GROUPMEMBERSONLY>0</GROUPMEMBERSONLY>
            <IDNUMBER>$@NULL@$</IDNUMBER>
            <ROLES_OVERRIDES>
            </ROLES_OVERRIDES>
            <ROLES_ASSIGNMENTS>
            </ROLES_ASSIGNMENTS>
          </MOD>
        </MODS>
      </SECTION>
    </SECTIONS>
  </COURSE>
</MOODLE_BACKUP>
XML
    @moodle_backup_path = File.expand_path("../../../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(@moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open("moodle.xml", "w") { |f| f.write xml }
    end
    @backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    @manifest = Moodle2CC::CC::Manifest.new
    @manifest.moodle_backup = @backup
  end

  def test_it_gets_the_title_from_the_section_number
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]').first

    assert_equal 'week 0', item.title
  end

  def test_it_gets_the_identifier_by_hashing_the_section_id
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]').first

    assert_equal 'i331f3f23437a39a4970a6a19317881f8', item.identifier
  end

  def test_it_creates_a_wiki_resource_from_the_summary_of_the_section
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]').first

    resource = @manifest.resources.first
    assert resource
    assert resource.identifier
    assert_equal resource.identifier, item.identifierref
  end

  def test_it_gets_the_title_from_the_module
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]/MODS/MOD[1]').first

    assert_equal 'Create a Rails site', item.title
  end

  def test_it_gets_the_identifier_by_hashing_the_mod_id
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]/MODS/MOD[1]').first

    assert_equal 'i2a72d79e274dcae2b276ba7177245ccb', item.identifier
  end
end
