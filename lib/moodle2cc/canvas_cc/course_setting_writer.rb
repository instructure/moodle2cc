class Moodle2CC::CanvasCC::CourseSettingWriter

  SETTINGS_POSTFIX = '_settings'
  COURSE_SETTINGS_FILE = 'course_settings.xml'

  def initialize(work_dir, course)
    @work_dir = work_dir
    @course = course
  end

  def write
    xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      course(xml) do |xml|
        @course.settings.each { |k, v| xml.send(k, v) }
      end
    end.to_xml
    File.open(File.join(@work_dir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, COURSE_SETTINGS_FILE), 'w' ) {|f| f.write(xml)}
  end

  private

  def course(xml)
    xml.course(
      'identifier' => @course.identifier + SETTINGS_POSTFIX,
      'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
    ) {
      yield xml
    }
  end

end