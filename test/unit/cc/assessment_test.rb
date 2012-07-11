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

  def test_it_converts_description
    @mod.intro = %(<h1>Hello World</h1><img src="$@FILEPHP@$$@SLASH@$folder$@SLASH@$stuff.jpg" />)
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal %(<h1>Hello World</h1><img src="$IMS_CC_FILEBASE$/folder/stuff.jpg" />), assessment.description
  end

  def test_it_converts_lock_at
    @mod.time_close = Time.parse("2012/12/12 12:12:12 +0000").to_i
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal '2012-12-12T12:12:12', assessment.lock_at
  end

  def test_it_converts_unlock_at
    @mod.time_open = Time.parse("2012/12/12 12:12:12 +0000").to_i
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal '2012-12-12T12:12:12', assessment.unlock_at
  end

  def test_it_converts_time_limit
    @mod.time_limit = 45
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 45, assessment.time_limit
  end

  def test_it_converts_allowed_attempts
    @mod.attempts_number = 2
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 2, assessment.allowed_attempts
  end

  def test_it_converts_scoring_policy
    @mod.grade_method = 1
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'keep_highest', assessment.scoring_policy

    @mod.grade_method = 2
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'keep_highest', assessment.scoring_policy

    @mod.grade_method = 3
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'keep_highest', assessment.scoring_policy

    @mod.grade_method = 4
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'keep_latest', assessment.scoring_policy
  end

  def test_it_converts_access_code
    @mod.password = 'password'
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'password', assessment.access_code
  end

  def test_it_converts_ip_filter
    @mod.subnet = '127.0.0.1'
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal '127.0.0.1', assessment.ip_filter
  end

  def test_it_converts_shuffle_answers
    @mod.shuffle_answers = true
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal true, assessment.shuffle_answers
  end

  def test_it_has_an_identifier
    @mod.id = 321
    assessment = Moodle2CC::CC::Assessment.new @mod
    assert_equal 'i058d7533a77712b6e7757b34e66df7fc', assessment.identifier
  end
end
