require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2Converter
  class MigratorTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
    end

    def teardown
      # Do nothing
    end

    def test_migration
      canvas_course = Moodle2CC::CanvasCC::Model::Course.new
      canvas_module = Moodle2CC::CanvasCC::Model::CanvasModule.new
      extractor_mock do
        mock_converter(Moodle2CC::Moodle2Converter::CourseConverter, canvas_course) do
          mock_converter(Moodle2CC::Moodle2Converter::SectionConverter, canvas_module) do
            cartridge_mock do
              migrator = Moodle2CC::Moodle2Converter::Migrator.new('source_path', 'output_dir')
              assert_equal(migrator.migrate, 'my_output_file')
            end
          end
        end
      end
    end

    private

    def mock_converter(converter_class, return_obj)
      converter_mock = MiniTest::Mock.new
      converter_mock.expect(:convert, return_obj, [Object])
      converter_class.stub(:new, converter_mock) do
        yield
      end
    end

    def cartridge_mock
      mock_cartridge_creator = MiniTest::Mock.new
      mock_cartridge_creator.expect(:create, 'my_output_file', [Object])
      Moodle2CC::CanvasCC::CartridgeCreator.stub(:new, mock_cartridge_creator) do
        yield
      end
    end

    def extractor_mock
      moodle_course = Moodle2CC::Moodle2::Model::Course.new
      moodle_course.sections << Moodle2CC::Moodle2::Model::Section.new
      mock_extractor = MiniTest::Mock.new
      mock_extractor.expect(:extract, moodle_course)
      Moodle2CC::Moodle2::Extractor.stub(:new, mock_extractor) do
        yield
      end
      mock_extractor.verify
    end

  end
end
