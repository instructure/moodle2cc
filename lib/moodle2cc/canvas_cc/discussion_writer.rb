module Moodle2CC::CanvasCC
  class DiscussionWriter

    def initialize(work_dir, *canvas_discussions)
      @work_dir = work_dir
      @discussions = canvas_discussions
    end

    def write
      @discussions.each do |discussion|
        write_discussion(discussion)
        write_meta(discussion)
      end
    end


    private

    def write_discussion(discussion)
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.topic('xmlns' => 'http://www.imsglobal.org/xsd/imsccv1p1/imsdt_v1p1',
                  'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                  'xsi:schemaLocation' => 'http://www.imsglobal.org/xsd/imsccv1p1/imsdt_v1p1  http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imsdt_v1p1.xsd'
        ) { |xml|
          xml.title discussion.title
          xml.text_('texttype' => 'text/html') { xml.text discussion.text }
        }
      end.to_xml
      File.open(File.join(@work_dir, discussion.discussion_resource.files.first), 'w') { |f| f.write(xml) }
    end

    def write_meta(discussion)
      meta_resource = discussion.meta_resource
      discussion_resource = discussion.discussion_resource
      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.topicMeta('identifier' => meta_resource.identifier, 'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                      'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
        ) { |xml|
          xml.topic_id discussion_resource.identifier
          xml.title discussion.title
          xml.position
          xml.type 'topic'
          xml.discussion_type discussion.discussion_type
        }
      end.to_xml
      File.open(File.join(@work_dir, meta_resource.href), 'w') { |f| f.write(xml) }
    end

  end
end