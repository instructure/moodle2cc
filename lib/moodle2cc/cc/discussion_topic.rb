module Moodle2CC::CC
  class DiscussionTopic
    include CCHelper

    attr_accessor :id, :title, :posted_at, :position, :type, :text

    def initialize(mod, position=0)
      @id = mod.id
      @title = mod.name
      @text = mod.intro

      if mod.section_mod && mod.section_mod.added.to_i > 0
        @posted_at = ims_datetime(Time.at(mod.section_mod.added))
      end

      @position = position
      @type = 'topic'
    end

    def identifier
      create_key(id, 'resource_')
    end

    def identifierref
      create_key(id, 'topic_meta_')
    end

    def create_resource_node(resources_node)
      identifier = create_key(@id, 'resource_')
      dependency_ref = create_key(@id, 'topic_meta_')

      resources_node.resource(
        :type => DISCUSSION_TOPIC,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => "#{identifier}.xml")
        resource_node.dependency(:identifierref => dependency_ref)
      end
      resources_node.resource(
        :type => LOR,
        :identifier => dependency_ref,
        :href => "#{dependency_ref}.xml"
      ) do |resource_node|
        resource_node.file(:href => "#{dependency_ref}.xml")
      end
    end

    def create_files(export_dir)
      create_topic_xml(export_dir)
      create_topic_meta_xml(export_dir)
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

    def create_topic_meta_xml(export_dir)
      path = File.join(export_dir, "#{identifierref}.xml")
      File.open(path, 'w') do |file|
        document = Builder::XmlMarkup.new(:target => file, :indent => 2)
        document.instruct!
        document.topicMeta(
          :identifier => identifierref,
          'xsi:schemaLocation' => "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'xmlns' => "http://canvas.instructure.com/xsd/cccv1p0"
        ) do |topic_meta|
          topic_meta.topic_id identifier
          topic_meta.title @title
          topic_meta.posted_at @posted_at
          topic_meta.position @position
          topic_meta.type @type
        end
      end
    end
  end
end
