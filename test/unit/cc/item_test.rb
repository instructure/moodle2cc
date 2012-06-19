require 'minitest/autorun'
require 'moodle2cc'

class TestUnitCCItem < MiniTest::Unit::TestCase
  def setup
    xml = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<MOODLE_BACKUP>
  <INFO>
    <NAME>moodle_backup.zip</NAME>
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
          <MOD>
            <ID>22222</ID>
            <TYPE>resource</TYPE>
            <INSTANCE>876</INSTANCE>
            <ADDED>1338472800</ADDED>
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
          <MOD>
            <ID>33333</ID>
            <TYPE>forum</TYPE>
            <INSTANCE>765</INSTANCE>
            <ADDED>1338472800</ADDED>
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
    <MODULES>
      <MOD>
        <ID>987</ID>
        <MODTYPE>assignment</MODTYPE>
        <NAME>Create a Rails site</NAME>
        <DESCRIPTION>&lt;h1&gt;Hello World&lt;/h1&gt;</DESCRIPTION>
        <FORMAT>0</FORMAT>
        <RESUBMIT>0</RESUBMIT>
        <PREVENTLATE>0</PREVENTLATE>
        <EMAILTEACHERS>0</EMAILTEACHERS>
        <VAR1>0</VAR1>
        <VAR2>0</VAR2>
        <VAR3>0</VAR3>
        <VAR4>0</VAR4>
        <VAR5>0</VAR5>
        <ASSIGNMENTTYPE>offline</ASSIGNMENTTYPE>
        <MAXBYTES>100000</MAXBYTES>
        <TIMEDUE>0</TIMEDUE>
        <TIMEAVAILABLE>0</TIMEAVAILABLE>
        <GRADE>5</GRADE>
        <TIMEMODIFIED>1338485904</TIMEMODIFIED>
      </MOD>
      <MOD>
        <ID>876</ID>
        <MODTYPE>resource</MODTYPE>
        <NAME>About Your Instructor</NAME>
        <TYPE>file</TYPE>
        <REFERENCE>http://en.wikipedia.org/wiki/Einstein</REFERENCE>
        <SUMMARY></SUMMARY>
        <ALLTEXT></ALLTEXT>
        <POPUP>resizable=1,scrollbars=1,directories=1,location=1,menubar=1,toolbar=1,status=1,width=1024,height=768</POPUP>
        <OPTIONS></OPTIONS>
        <TIMEMODIFIED>1338472800</TIMEMODIFIED>
      </MOD>
      <MOD>
        <ID>765</ID>
        <MODTYPE>forum</MODTYPE>
        <TYPE>news</TYPE>
        <NAME>Announcements</NAME>
        <INTRO>General news and announcements</INTRO>
        <ASSESSED>0</ASSESSED>
        <ASSESSTIMESTART>0</ASSESSTIMESTART>
        <ASSESSTIMEFINISH>0</ASSESSTIMEFINISH>
        <MAXBYTES>0</MAXBYTES>
        <SCALE>0</SCALE>
        <FORCESUBSCRIBE>1</FORCESUBSCRIBE>
        <TRACKINGTYPE>1</TRACKINGTYPE>
        <RSSTYPE>0</RSSTYPE>
        <RSSARTICLES>0</RSSARTICLES>
        <TIMEMODIFIED>1338472516</TIMEMODIFIED>
        <WARNAFTER>0</WARNAFTER>
        <BLOCKAFTER>0</BLOCKAFTER>
        <BLOCKPERIOD>0</BLOCKPERIOD>
      </MOD>
    </MODULES>
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

  def test_it_creates_a_weblink_resource
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]/MODS/MOD[2]').first

    resource = @manifest.resources.first
    assert resource
    assert resource.identifier
    assert_equal resource.identifier, item.identifierref
    assert_equal "imswl_xmlv1p1", resource.type
    assert_equal "http://en.wikipedia.org/wiki/Einstein", resource.href
  end

  def test_it_creates_a_discussion_topic_resource
    item = Moodle2CC::CC::Item.from_manifest @manifest, @backup.course.xpath('SECTIONS/SECTION[1]/MODS/MOD[3]').first

    resource = @manifest.resources.first
    assert resource
    assert resource.identifier
    assert_equal resource.identifier, item.identifierref
    assert_equal "imsdt_xmlv1p1", resource.type
    assert_equal "Announcements", resource.title
    assert_equal "General news and announcements", resource.text
  end
end
