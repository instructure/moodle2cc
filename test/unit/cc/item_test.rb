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

  def test_it_references_a_weblink_resource
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]/MODS/MOD[2]').first

    resource = @manifest.resources.first
    assert_equal resource.identifier, item.identifierref
  end

  def test_it_references_a_discussion_topic_resource
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]/MODS/MOD[3]').first

    resource = @manifest.resources.first
    assert_equal resource.identifier, item.identifierref
  end
end
