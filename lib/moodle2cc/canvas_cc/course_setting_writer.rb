class Moodle2CC::CanvasCC::CourseSettingWriter

  def initialize(course, identifier)
    @course = course
    @identifier = identifier
  end

  def write
    Nokogiri::XML::Builder.new do |xml|
      course(xml) do |xml|
        @course.settings.each { |k,v| xml.send(k, v) }
      end
    end.to_xml
  end

  private

  def course(xml)
    xml.course(
      'identifier'         => @identifier,
      'xmlns'              => 'http://canvas.instructure.com/xsd/cccv1p0',
      'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
    ) {
      yield xml
    }
  end

end