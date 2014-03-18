module Moodle2CC::CanvasCC::Models
  class Discussion
    attr_accessor :identifier, :title, :text, :discussion_type
    DISCUSSION_ID_POSTFIX = '_DISCUSSION'
    DISCUSSION_META_POSTFIX = '_meta'
    IMSDT_TYPE = 'imsdt_xmlv1p1'
    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'

    def resources
      #generate_meta_resource
      [discussion_resource, meta_resource]
    end

    def discussion_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.dependencies << resource.identifier + DISCUSSION_META_POSTFIX
      resource.type = IMSDT_TYPE
      resource.files << resource.identifier + '.xml'

      resource
    end

    def meta_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = @identifier + DISCUSSION_META_POSTFIX
      resource.type = LAR_TYPE
      file_name = resource.identifier + '.xml'
      resource.href = file_name
      resource.files << file_name

      resource
    end

  end
end