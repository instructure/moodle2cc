class Moodle2CC::ResourceFactory

  def initialize(namespace)
    @namespace = namespace
  end

  def get_resource_from_mod(mod, position=0)
    case mod.mod_type
    when 'assignment', 'workshop'
      @namespace.const_get(:Assignment).new(mod, position)
    when 'resource'
      case mod.type
      when 'file'
        @namespace.const_get(:WebLink).new(mod)
      when 'html', 'text'
        @namespace.const_get(:WebContent).new(mod)
      end
    when 'forum'
      @namespace.const_get(:DiscussionTopic).new(mod, position)
    when 'quiz', 'questionnaire', 'choice'
      @namespace.const_get(:Assessment).new(mod, position)
    when 'wiki'
      @namespace.const_get(:Wiki).new(mod)
    when 'label', 'summary'
      html = Nokogiri::HTML(mod.content)
      if html.search('img[src]').length > 0 ||
        html.search('a[href]').length > 0 ||
        html.search('iframe[src]').length > 0 ||
        html.text.strip.length > 50
        @namespace.const_get(:WebContent).new(mod)
      else
        @namespace.const_get(:Label).new(mod)
      end
    end
  end
end
