module Moodle2CC
  module CC
  class DiscussionTopic
    include CCHelper
    include Resource

    attr_accessor :text

    def initialize(mod, position=0)
      super
      @text = convert_file_path_tokens(mod.intro)
    end

    def identifierref
      create_key(id, 'topic_meta_')
    end

    def create_resource_node(resources_node)
      resources_node.resource(
        :type => DISCUSSION_TOPIC,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => "#{identifier}.xml")
        create_resource_sub_nodes(resource_node)
      end
    end

    def create_resource_sub_nodes(resource_node)
    end

    def create_files(export_dir)
      create_topic_xml(export_dir)
    end

    def create_topic_xml(export_dir)
      path = File.join(export_dir, "#{identifier}.xml")
      File.open(path, 'w') do |file|
        document = Builder::XmlMarkup.new(:target => file, :indent => 2)
        document.instruct!
        document.topicMeta(
          :identifier => identifierref,
          'xsi:schemaLocation' => "http://www.imsglobal.org/xsd/imsccv1p1/imsdt_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imsdt_v1p1.xsd",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'xmlns' => "http://www.imsglobal.org/xsd/imsccv1p1/imsdt_v1p1"
        ) do |topic|
          topic.title @title
          topic.text @text, :texttype => 'text/html'
        end
      end
    end
  end
end
end
