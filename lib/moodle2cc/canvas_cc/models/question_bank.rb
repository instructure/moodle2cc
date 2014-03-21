module Moodle2CC::CanvasCC::Models
  class QuestionBank

    attr_accessor :identifier, :title, :questions

    def initialize
      @questions = []
    end

    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSESSMENT_NON_CC_FOLDER = 'non_cc_assessments'

    def resources
      [question_bank_resource]
    end

    def question_bank_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.href = "#{ASSESSMENT_NON_CC_FOLDER}/#{resource.identifier}.xml.qti"
      resource.type = LAR_TYPE
      resource.files = [resource.href]
      resource
    end
  end
end