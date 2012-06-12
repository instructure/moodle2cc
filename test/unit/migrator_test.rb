require 'minitest/autorun'
require 'moodle2cc'

class TestUnitMigrator < MiniTest::Unit::TestCase
  def setup
    @valid_source = File.expand_path("../../fixtures/moodle_backup.zip", __FILE__)
    @valid_destination = File.expand_path("../../tmp", __FILE__)
  end

  def test_it_accepts_a_source_and_destination
    migrator = Moodle2CC::Migrator.new @valid_source, @valid_destination
    assert migrator
  end

  def test_source_must_exist
    assert_raises Moodle2CC::Error, "'does_not_exist' does not exist" do
      Moodle2CC::Migrator.new 'does_not_exist', 'there'
    end
  end

  def test_destination_must_be_a_directory
    assert_raises Moodle2CC::Error, "'is_not_a_directory' is not a directory" do
      Moodle2CC::Migrator.new @valid_source, 'is_not_a_directory'
    end
  end
end
