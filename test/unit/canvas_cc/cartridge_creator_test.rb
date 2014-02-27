require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class CartridgeCreatorTest < MiniTest::Unit::TestCase
    include TestHelper

    class CCFileTest < CartridgeCreatorTest

      def setup
        @tmpdir = Dir.mktmpdir
        course = Moodle2CC::CanvasCC::Model::Course.new
        course.identifier = 'setting'
        course.title = 'My Course'
        course.canvas_modules << Moodle2CC::CanvasCC::Model::CanvasModule.new
        @cartridge_creator = Moodle2CC::CanvasCC::CartridgeCreator.new(course)
        @ims_generator_mock = MiniTest::Mock.new
        @ims_generator_mock.expect(:write, 'lorem ipsum')
        @writers = []
      end

      def teardown
        FileUtils.rm_r @tmpdir
      end

      def test_zipfile_creation

        expect_writer Moodle2CC::CanvasCC::CanvasExportWriter
        expect_writer Moodle2CC::CanvasCC::CourseSettingWriter
        expect_writer Moodle2CC::CanvasCC::ImsManifestGenerator
        expect_writer Moodle2CC::CanvasCC::ModuleMetaWriter
        expect_writer Moodle2CC::CanvasCC::FileMetaWriter
        expect_writer Moodle2CC::CanvasCC::PageWriter

        verify_writers do
          imscc_path = @cartridge_creator.create(@tmpdir)
          assert File.exist?(imscc_path)
        end
      end

      def test_filename
        course = Moodle2CC::CanvasCC::Model::Course.new
        course.title = 'Course Title'
        cartridge_creator = Moodle2CC::CanvasCC::CartridgeCreator.new(course)
        assert_equal(cartridge_creator.filename, 'course_title.imscc')
      end

      private

      def expect_writer(writer)
        @writers << writer
      end

      def verify_writers
        expected_writers(*@writers) { yield }
      end

      def expected_writers(*writer_classes)
        if writer_classes.count > 1
          mock_writer(writer_classes.first) do
            expected_writers(*writer_classes.drop(1)) { yield }
          end
        else
          mock_writer(writer_classes.first) { yield }
        end
      end

      def mock_writer(writer_class)
        writer_mock = MiniTest::Mock.new
        writer_mock.expect(:write, nil)
        writer_class.stub(:new, writer_mock) do
          yield
        end
        writer_mock.verify
      end

    end
  end
end