require 'minitest/autorun'
require 'moodle2cc'
require 'zip/zipfilesystem'

class TestUnitCCManifest < MiniTest::Unit::TestCase
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

  def test_it_gets_basic_attributes_from_backup
    backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    manifest = Moodle2CC::CC::Manifest.from_moodle_backup backup
    assert_equal 'My Course', manifest.title
  end
end
