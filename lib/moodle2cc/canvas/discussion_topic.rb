module Moodle2CC::Canvas
  class DiscussionTopic < Moodle2CC::CC::DiscussionTopic
    include Resource
    attr_accessor :posted_at, :position, :type, :identifierref

    def initialize(mod, position=0)
      super
      @text = convert_file_path_tokens(mod.intro)

      if mod.section_mod && mod.section_mod.added.to_i > 0
        @posted_at = ims_datetime(Time.at(mod.section_mod.added))
      end

      @position = position
      @type = 'topic'
      @identifierref = create_key(@id, 'topic_meta_')
    end

    def create_resource_node(resources_node)
      super
      resources_node.resource(
        :type => LOR,
        :identifier => @identifierref,
        :href => "#{@identifierref}.xml"
      ) do |resource_node|
        resource_node.file(:href => "#{@identifierref}.xml")
      end
    end

    def create_resource_sub_nodes(resource_node)
      resource_node.dependency(:identifierref => @identifierref)
    end

    def create_files(export_dir)
      super
      create_topic_meta_xml(export_dir)
    end

    def create_topic_meta_xml(export_dir)
      path = File.join(export_dir, "#{@identifierref}.xml")
      File.open(path, 'w') do |file|
        document = Builder::XmlMarkup.new(:target => file, :indent => 2)
        document.instruct!
        document.topicMeta(
          :identifier => @identifierref,
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

    def create_module_meta_item_elements(item_node)
      item_node.content_type 'DiscussionTopic'
      item_node.identifierref @identifier
    end
  end
end
