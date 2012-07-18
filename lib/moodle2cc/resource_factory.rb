class Moodle2CC::ResourceFactory

  def initialize(namespace)
    @namespace = namespace
  end

  def get_resource_from_mod(mod, position=0)
    case mod.mod_type
    when 'assignment', 'workshop'
      @namespace.const_get(:Assignment).new(mod, position)
    when 'resource'
      if mod.type == 'file'
        @namespace.const_get(:WebLink).new(mod)
      elsif mod.type == 'html'
        @namespace.const_get(:WebContent).new(mod)
      end
    when 'forum'
      @namespace.const_get(:DiscussionTopic).new(mod, position)
    when 'quiz', 'questionnaire', 'choice'
      @namespace.const_get(:Assessment).new(mod, position)
    when 'wiki'
      @namespace.const_get(:Wiki).new(mod)
    when 'label'
      html = Nokogiri::HTML(mod.content)
      if html.text == mod.content && mod.content.length < 50 # label doesn't contain HTML
        @namespace.const_get(:Label).new(mod)
      else
        @namespace.const_get(:WebContent).new(mod)
      end
    end
  end
end
