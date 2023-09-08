module Moodle2CC::CanvasCC
  class AssessmentWriter

    def initialize(work_dir, *assessments)
      @work_dir = work_dir
      @assessments = assessments
    end

    def write
      @assessments.each do |assessment|
        write_assessment(assessment)
      end
    end

    private

    def write_assessment(assessment)
      write_assessment_non_cc_qti_xml(assessment)
      write_assessment_meta_xml(assessment)
    end

    def write_assessment_meta_xml(assessment)
      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.quiz(
            :identifier => assessment.identifier,
            'xsi:schemaLocation' => "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd",
            'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
            'xmlns' => "http://canvas.instructure.com/xsd/cccv1p0"
        ) do |quiz_node|
          Moodle2CC::CanvasCC::Models::Assessment::META_ATTRIBUTES.each do |attr|
            quiz_node.send(attr, assessment.send(attr)) unless assessment.send(attr).nil?
          end
          Moodle2CC::CanvasCC::Models::Assessment::DATETIME_ATTRIBUTES.each do |attr|
            quiz_node.send(attr, Moodle2CC::CC::CCHelper.ims_datetime(assessment.send(attr))) unless assessment.send(attr).nil?
          end
        end
      end.to_xml

      file_path = File.join(@work_dir, assessment.meta_file_path)
      FileUtils.mkdir_p(File.dirname(file_path)) unless File.exist?(File.dirname(file_path))
      File.open(file_path, 'w') { |f| f.write(xml) }
    end

    def write_assessment_non_cc_qti_xml(assessment)
      raise "need to resolve questions references" if assessment.items.nil?

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.questestinterop("xmlns" => "http://www.imsglobal.org/xsd/ims_qtiasiv1p2",
                            "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
                            "xsi:schemaLocation"=> "http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd"
        ) { |xml|
          xml.assessment(:title => assessment.title, :ident => assessment.identifier) do |assessment_node|
            assessment_node.qtimetadata do |qtimetadata_node|
              qtimetadata_node.qtimetadatafield do |qtimetadatafield_node|
                qtimetadatafield_node.fieldlabel "qmd_timelimit"
                qtimetadatafield_node.fieldentry assessment.time_limit
              end
              qtimetadata_node.qtimetadatafield do |qtimetadatafield_node|
                qtimetadatafield_node.fieldlabel "cc_maxattempts"
                qtimetadatafield_node.fieldentry assessment.allowed_attempts
              end
            end
            assessment_node.section(:ident => 'root_section') do |section_node|
              assessment.items.each do |item|
                case item
                when Moodle2CC::CanvasCC::Models::Question
                  Moodle2CC::CanvasCC::QuestionWriter.write_question(section_node, item)
                when Moodle2CC::CanvasCC::Models::QuestionGroup
                  Moodle2CC::CanvasCC::QuestionGroupWriter.write_question_group(section_node, item)
                end
              end
            end
          end
        }
      end.to_xml

      file_path = File.join(@work_dir, assessment.qti_file_path)
      FileUtils.mkdir_p(File.dirname(file_path)) unless File.exist?(File.dirname(file_path))
      File.open(file_path, 'w') { |f| f.write(xml) }
    end
  end
end