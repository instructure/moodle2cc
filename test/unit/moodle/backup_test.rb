require 'minitest/autorun'
require 'moodle2cc'
require 'zip/zipfilesystem'

class TestUnitMoodleBackup < MiniTest::Unit::TestCase
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
          <ID>1</ID>
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
      <ID>12345</ID>
      <FULLNAME>My Course</FULLNAME>
      <SHORTNAME>EDU 101</SHORTNAME>
    </HEADER>
  </COURSE>
</MOODLE_BACKUP>
XML
    @moodle_backup_path = File.expand_path("../../../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(@moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open("moodle.xml", "w") { |f| f.write xml }
    end
  end

  def test_it_stores_the_xml_file
    backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    assert_instance_of Nokogiri::XML::Document, backup.xml
  end

  def test_is_has_info
    backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    assert_instance_of Nokogiri::XML::Element, backup.info
    assert_equal 'INFO', backup.info.name
  end

  def test_it_has_a_course
    backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    assert_instance_of Nokogiri::XML::Element, backup.course
    assert_equal 'COURSE', backup.course.name
  end
end
