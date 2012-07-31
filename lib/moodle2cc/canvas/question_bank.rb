module Moodle2CC::Canvas
  class QuestionBank
    include Moodle2CC::CC::CCHelper
    attr_accessor :id, :title, :questions, :identifier

    def initialize(question_category)
      @id = question_category.id
      @title = question_category.name
      @identifier = create_key(@id, 'objectbank_')
      @question_category = question_category
      @questions = @question_category.questions.reject { |q| q.type == 'random' }.map do |question|
        Question.new question
      end
    end

    def create_resource_node(resources_node)
      href = File.join(ASSESSMENT_NON_CC_FOLDER, "#{identifier}.xml.qti")
      resources_node.resource(
        :href => href,
        :type => LOR,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => href)
      end
    end

    def create_files(export_dir)
      create_qti_xml(export_dir)
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
          root_node.objectbank(:ident => identifier) do |objectbank_node|
            objectbank_node.qtimetadata do |qtimetadata_node|
              qtimetadata_node.qtimetadatafield do |qtimetadatafield_node|
                qtimetadatafield_node.fieldlabel "bank_title"
                qtimetadatafield_node.fieldentry @title
              end
            end
            @questions.each do |question|
              question.create_item_xml(objectbank_node) if question
            end
          end
        end
      end
    end
  end
end
