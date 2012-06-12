require 'minitest/autorun'
require 'moodle2cc'

class TestAcceptanceMigrator < MiniTest::Unit::TestCase
  def setup
    @source = File.expand_path("../../fixtures/moodle_backup.zip", __FILE__)
    @destination = File.expand_path("../../tmp", __FILE__)
    @package = File.expand_path("../../tmp/moodle_backup.imscc", __FILE__)
  end

  def teardown
    Dir[File.expand_path("../../tmp/**", __FILE__)].each { |file| FileUtils.rm file }
  end

  def test_it_creates_a_cc_package
    migrator = Moodle2CC::Migrator.new @source, @destination
    migrator.migrate
    assert File.exists?(@package), "#{@package} not created"
  end
end
