module Moodle2CC::CC
  class Assessment
    include CCHelper
    include Resource

    META_ATTRIBUTES = [:title, :description, :lock_at, :unlock_at, :allowed_attempts,
      :scoring_policy, :access_code, :ip_filter, :shuffle_answers, :time_limit, :quiz_type]

    attr_accessor :non_cc_assessments_identifier, *META_ATTRIBUTES

    def initialize(mod, position=0)
      super
      description = mod.intro
      description = mod.content || '' if description.nil? || description.length == 0
      @description = convert_file_path_tokens(description)
      if mod.time_close.to_i > 0
        @lock_at = ims_datetime(Time.at(mod.time_close))
      end
      if mod.time_open.to_i > 0
        @unlock_at = ims_datetime(Time.at(mod.time_open))
      end
      @time_limit = mod.time_limit
      @allowed_attempts = mod.attempts_number
      @scoring_policy = mod.grade_method == 4 ? 'keep_latest' : 'keep_highest'
      @access_code = mod.password
      @ip_filter = mod.subnet
      @shuffle_answers = mod.shuffle_answers
      @quiz_type = mod.mod_type == 'questionnaire' ? 'survey' : 'practice_quiz'
      @non_cc_assessments_identifier = create_key(@id, 'non_cc_assessments_')
    end

    def create_resource_node(resources_node)
      href = File.join(identifier, ASSESSMENT_META)
      resources_node.resource(
        :href => href,
        :type => LOR,
        :identifier => non_cc_assessments_identifier
      ) do |resource_node|
        resource_node.file(:href => href)
        resource_node.file(:href => File.join(ASSESSMENT_NON_CC_FOLDER, "#{identifier}.xml.qti"))
      end
    end

    def create_files(export_dir)
      create_assessment_meta_xml(export_dir)
      create_qti_xml(export_dir)
    end

    def create_assessment_meta_xml(export_dir)
      path = File.join(export_dir, identifier, ASSESSMENT_META)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        node = Builder::XmlMarkup.new(:target => file, :indent => 2)
        node.instruct!
        node.quiz(
          :identifier => identifier,
          'xsi:schemaLocation' => "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'xmlns' => "http://canvas.instructure.com/xsd/cccv1p0"
        ) do |quiz_node|
          META_ATTRIBUTES.each do |attr|
            quiz_node.tag!(attr, send(attr)) unless send(attr).nil?
          end
        end
      end
    end

    def create_qti_xml(export_dir)
      path = File.join(export_dir, ASSESSMENT_NON_CC_FOLDER, "#{identifier}.xml.qti")
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        node = Builder::XmlMarkup.new(:target => file, :indent => 2)
        node.instruct!
        node.questestinterop(
          'xsi:schemaLocation' => "http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'xmlns' => "http://www.imsglobal.org/xsd/ims_qtiasiv1p2"
        ) do |root_node|
          root_node.assessment(:title => title, :identifier => identifier) do |assessment_node|
            assessment_node.qtimetadata do |qtimetadata_node|
              qtimetadata_node.qtimetadatafield do |qtimetadatafield_node|
                qtimetadatafield_node.fieldlabel "qmd_timelimit"
                qtimetadatafield_node.fieldentry time_limit
              end
              qtimetadata_node.qtimetadatafield do |qtimetadatafield_node|
                qtimetadatafield_node.fieldlabel "cc_maxattempts"
                qtimetadatafield_node.fieldentry allowed_attempts
              end
            end
            assessment_node.section(:ident => 'root_section') do |section_node|
              @mod.questions.each do |question|
                question = Question.new question
                question.create_item_xml(section_node)
              end
            end
          end
        end
      end
    end

    def create_module_meta_item_elements(item_node)
      item_node.content_type 'Quiz'
      item_node.identifierref @identifier
    end
  end
end
