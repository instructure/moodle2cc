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
        course.title = 'My Course'
        @cartridge_creator = Moodle2CC::CanvasCC::CartridgeCreator.new(course)
        @ims_generator_mock = MiniTest::Mock.new
        @ims_generator_mock.expect(:generate, 'lorem ipsum')
      end

      def teardown
        FileUtils.rm_r @tmpdir
      end

      def test_zipfile_creation
        Moodle2CC::CanvasCC::ImsManifestGenerator.stub(:new, @ims_generator_mock) do
          imscc_path = @cartridge_creator.create(@tmpdir)
          assert File.exist?(imscc_path)
          Zip::File.open(imscc_path) do |f|
            assert f.find_entry('imsmanifest.xml'), 'imsmanifest.xml should exist'
            assert f.find_entry('course_settings/course_settings.xml'), 'course_settings.xml should exist'
            assert f.find_entry('course_settings/canvas_export.txt'), 'course_export.txt should exist'
          end
        end
      end

      def test_resource_creation
        course_seting_writer_mock = MiniTest::Mock.new
        course_seting_writer_mock.expect(:write, 'xml_body')
        Moodle2CC::CanvasCC::ImsManifestGenerator.stub(:new, @ims_generator_mock) do
          Moodle2CC::CanvasCC::CourseSettingWriter.stub(:new, course_seting_writer_mock) do
            course = Moodle2CC::CanvasCC::Model::Course.new
            course.title = 'My Course'
            course.identifier = 'course_id'
            Moodle2CC::CanvasCC::CartridgeCreator.new(course).create(@tmpdir)
            assert_equal(course.resources.count, 1)
            resource = course.resources.first
            assert_equal('associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.type)
            assert_equal('ea134da7ce0152b54fb73853f6d62644_settings', resource.identifier)
            assert_equal(1, resource.files.count)
            assert_equal('course_settings/course_settings.xml', resource.files.first)
            assert_equal('course_settings/canvas_export.txt', resource.href)
          end
        end
      end

      def test_filename
        course = Moodle2CC::CanvasCC::Model::Course.new
        course.title = 'Course Title'
        cartridge_creator = Moodle2CC::CanvasCC::CartridgeCreator.new(course)
        assert_equal(cartridge_creator.filename, 'course_title.imscc')
      end

    end
  end
end