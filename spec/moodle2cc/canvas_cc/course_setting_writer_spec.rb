require 'spec_helper'

module Moodle2CC::CanvasCC
  describe CourseSettingWriter do

    let(:course) { Moodle2CC::CanvasCC::Models::Course.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'xml contains the correct schema' do
      course.identifier = 'identifier'
      xml = write_xml(course)

      valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
      xsd = Nokogiri::XML::Schema(valid_schema)
      expect(xsd.validate(xml)).to be_true
    end

    it 'applies settings to xml' do
      course.title = 'course title'
      course.course_code = 'course code'
      course.identifier = 'settings_id'
      xml = write_xml(course)
      expect(xml.at_xpath('/xmlns:course/@identifier').text).to eq('CC_5ffb5df5a69b977df90452a3b5b420c3_settings')
      expect(xml.at_xpath('/xmlns:course/xmlns:title').text).to eq(course.title)
      expect(xml.at_xpath('/xmlns:course/xmlns:course_code').text).to eq(course.course_code)
    end

    private

    def write_xml(course)
      CourseSettingWriter.new(tmpdir, course).write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       CourseSettingWriter::COURSE_SETTINGS_FILE)
      Nokogiri::XML(File.read(path))
    end

  end
end