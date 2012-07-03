module Moodle2CC::CC
  class Assessment
    include CCHelper
    include Resource

    META_ATTRIBUTES = [:title, :description, :lock_at, :unlock_at, :allowed_attempts,
      :scoring_policy, :access_code, :ip_filter, :shuffle_answers]

    attr_accessor :id, :non_cc_assessments_identifier, *META_ATTRIBUTES

    def initialize(mod, position=0)
      super
      @id = mod.id
      @title = mod.name
      @description = convert_file_path_tokens(mod.intro)
      if mod.time_close.to_i > 0
        @lock_at = ims_datetime(Time.at(mod.time_close))
      end
      if mod.time_open.to_i > 0
        @unlock_at = ims_datetime(Time.at(mod.time_open))
      end
      @allowed_attempts = mod.attempts_number
      @scoring_policy = mod.grade_method == 4 ? 'keep_latest' : 'keep_highest'
      @access_code = mod.password
      @ip_filter = mod.subnet
      @shuffle_answers = mod.shuffle_answers
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

    def create_assessment_meta_xml(export_dir)
      path = File.join(export_dir, identifier, ASSESSMENT_META)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        settings_node = Builder::XmlMarkup.new(:target => file, :indent => 2)
        settings_node.instruct!
        settings_node.quiz(
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
  end
end
