require 'spec_helper'

module Moodle2CC::CanvasCC
  describe CanvasExportWriter do

    subject { CanvasExportWriter.new(tmpdir) }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it "writes to the export file" do
      subject.write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       CanvasExportWriter::CANVAS_EXPORT_FILE)
      expect(File.exist?(path)).to be_truthy
    end

  end
end