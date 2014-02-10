require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

class MigratorTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
  end

  def teardown
    # Do nothing
  end

  def test_migration
    mock_extractor = MiniTest::Mock.new
    mock_extractor.expect(:extract, nil)
    mock_course_converter = MiniTest::Mock.new
    mock_course_converter.expect(:convert, nil, [Object])
    Moodle2CC::Moodle2::Extractor.stub(:new, mock_extractor) do
      Moodle2CC::Moodle2Converter::CourseConverter.stub(:new, mock_course_converter) do
        Moodle2CC::CommonCartridge::CartridgeCreator.stub(:new, 'my_output_file') do
          migrator = Moodle2CC::Moodle2Converter::Migrator.new('source_path', 'output_dir')
          assert_equal(migrator.migrate, 'my_output_file')
        end
      end
    end
    mock_extractor.verify
    mock_course_converter.verify
  end

end