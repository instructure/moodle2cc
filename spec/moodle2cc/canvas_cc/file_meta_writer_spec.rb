require 'spec_helper'

module Moodle2CC::CanvasCC
  describe FileMetaWriter do

    let(:file) { Model::CanvasFile.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'xml contains the correct schema' do
      meta_writer = writer(file)
      meta_writer.stub(:copy_files) { nil }
      xml = write_xml(meta_writer)
      assert_xml_schema(xml)
    end

    private

    def writer(file)
      FileMetaWriter.new(tmpdir, file)
    end

    def write_xml(writer)
      writer.write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       FileMetaWriter::FILE_META_FILE)
      Nokogiri::XML(File.read(path))
    end

    def assert_xml_schema(xml)
      valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
      xsd = Nokogiri::XML::Schema(valid_schema)
      expect(xsd.validate(xml)).to be_empty
    end

  end
end