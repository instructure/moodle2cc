require 'minitest/autorun'
require 'moodle2cc'
require 'zip/zipfilesystem'

class TestUnitMoodleBackup < MiniTest::Unit::TestCase
  def test_it_converts_moodle_backup_to_hash
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
</MOODLE_BACKUP>
XML
    moodle_backup_path = File.expand_path("../../../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open("moodle.xml", "w") { |f| f.write xml }
    end

    backup = Moodle2CC::Moodle::Backup.new moodle_backup_path
    assert_equal({
      'MOODLE_BACKUP' => {
        'INFO' => {
          'NAME' => 'moodle_backup.zip',
          'DETAILS' => {
            'MOD' => {
              'NAME' => 'assignment',
              'INCLUDED' => 'true',
              'USERINFO' => 'true',
              'INSTANCES' => {
                'INSTANCE' => {
                  'ID' => '1',
                  'NAME' => 'Create a Rails site',
                  'INCLUDED' => 'true',
                  'USERINFO' => 'true'
                }
              }
            }
          }
        }
      }
    }, backup.attributes)
  end
end
