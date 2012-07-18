module Moodle2CC::CC
  class Assessment
    include CCHelper
    include Resource

    def initialize(mod, position=0)
      super
    end

    def create_resource_node(resources_node)
      resources_node.resource(
        :identifier => identifier,
        :type => ASSESSMENT_TYPE
      ) do |resource_node|
        create_resource_sub_nodes(resource_node)
      end
    end

    def create_resource_sub_nodes(resource_node)
    end

    def create_files(export_dir)
    end
  end
end
