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
</MOODLE_BACKUP>
XML
    @moodle_backup_path = File.expand_path("../../../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(@moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open("moodle.xml", "w") { |f| f.write xml }
    end
  end

  def test_it_has_hashie_mash_attributes
    backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    assert_instance_of Hashie::Mash, backup.attributes
  end

  def test_it_converts_moodle_backup_to_mash
    backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    attrs = Hashie::Mash.new(
      'moodle_backup' => {
        'info' => {
          'name' => 'moodle_backup.zip',
          'details' => {
            'mod' => {
              'name' => 'assignment',
              'included' => 'true',
              'userinfo' => 'true',
              'instances' => {
                'instance' => {
                  'id' => '1',
                  'name' => 'Create a Rails site',
                  'included' => 'true',
                  'userinfo' => 'true'
                }
              }
            }
          }
        }
      }
    )

    assert_equal attrs, backup.attributes
  end
end
