require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class FileMetaWriterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @file = Moodle2CC::CanvasCC::Model::CanvasFile.new
      @tmpdir = Dir.mktmpdir
      Dir.mkdir(File.join(@tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    def teardown
      FileUtils.rm_r @tmpdir
    end

    def test_schema
      @file.file
      meta_writer = writer(@file)
      meta_writer.stub(:copy_files, nil) do
        xml = write_xml(meta_writer)
        assert_xml_schema xml
      end
    end

    def test_file_copying
      Dir.mktmpdir do |dir|
        source_file = File.join(dir, 'sample.txt')
        FileUtils.touch(source_file)
        @file.file_location = source_file
        @file.file_path = 'sample.txt'
        write_xml(writer(@file))
        assert(File.exist?(File.join(@tmpdir, Moodle2CC::CanvasCC::Model::CanvasFile::WEB_RESOURCES, 'sample.txt')), 'sample.txt must exist in the web resources dir')
      end
    end

    private

    def writer(file)
      Moodle2CC::CanvasCC::FileMetaWriter.new(@tmpdir, file)
    end

    def write_xml(writer)
      writer.write
      Nokogiri::XML(File.read(File.join(@tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, Moodle2CC::CanvasCC::FileMetaWriter::FILE_META_FILE)))
    end

    def assert_xml_schema(xml)
      xsd = Nokogiri::XML::Schema(File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd'))))
      assert_empty(xsd.validate(xml))
    end

  end
end
