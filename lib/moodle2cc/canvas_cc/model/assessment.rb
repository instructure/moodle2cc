module Moodle2CC::CanvasCC::Model
  class Assessment

    attr_accessor :identifier, :title, :description, :lock_at, :unlock_at, :allowed_attempts,
                   :scoring_policy, :access_code, :ip_filter, :shuffle_answers, :time_limit, :quiz_type

    ASSESSMENT_ID_POSTFIX = '_ASSESSMENT'
    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSESSMENT_NON_CC_FOLDER = 'non_cc_assessments'

    def resources
      [assessment_resource]
    end

    def assessment_resource
      resource = Moodle2CC::CanvasCC::Model::Resource.new
      resource.identifier = @identifier
      resource.ident_postfix = ASSESSMENT_ID_POSTFIX
      resource.href = "#{resource.identifier}/assessment_meta.xml"
      resource.type = LAR_TYPE
      resource.files = [resource.href, "#{ASSESSMENT_NON_CC_FOLDER}/#{resource.identifier}.xml.qti"]
    end
  end
end