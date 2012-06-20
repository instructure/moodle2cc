require 'minitest/autorun'
require 'moodle2cc'

class TestUnitCCItem < MiniTest::Unit::TestCase
  def setup
    @moodle_backup_path = File.expand_path("../../../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(@moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open("moodle.xml", "w") { |f| f.write File.read(File.expand_path("../../../fixtures/moodle.xml", __FILE__)) }
    end
    @backup = Moodle2CC::Moodle::Backup.parse @moodle_backup_path
    @manifest = Moodle2CC::CC::Manifest.new
    @manifest.moodle_backup = @backup
  end

  def test_it_creates_a_weblink_resource
    Moodle2CC::CC::Resource.from_manifest @manifest, @backup.course.xpath('MODULES/MOD[2]').first

    resource = @manifest.resources.first
    assert resource
    assert resource.identifier
    assert_equal "imswl_xmlv1p1", resource.type
    assert_equal "http://en.wikipedia.org/wiki/Einstein", resource.href
  end

  def test_it_creates_a_discussion_topic_resource
    Moodle2CC::CC::Resource.from_manifest @manifest, @backup.course.xpath('MODULES/MOD[3]').first

    resource = @manifest.resources.first
    assert resource
    assert resource.identifier
    assert_equal "imsdt_xmlv1p1", resource.type
    assert_equal "Announcements", resource.title
    assert_equal "General news and announcements", resource.text
  end
end
