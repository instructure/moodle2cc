require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class CanvasExportWriterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @tmpdir = Dir.mktmpdir
      Dir.mkdir(File.join(@tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    def teardown
      FileUtils.rm_r @tmpdir
    end

    def test_export_file
      Moodle2CC::CanvasCC::CanvasExportWriter.new(@tmpdir).write
      assert(File.exist?(File.join(@tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, Moodle2CC::CanvasCC::CanvasExportWriter::CANVAS_EXPORT_FILE)), 'the export file must exist')
    end

  end
end