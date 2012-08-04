module Moodle2CC::Canvas
  class Wiki < Moodle2CC::CC::Wiki
    include Resource
    attr_accessor :pages

    def initialize(mod)
      @href_template = "#{WIKI_FOLDER}/%s.html"
      super

      @pages.map! do |page|
        page.body.gsub!(/\[(.*?)\]/) do |match|
          title_slug = file_slug(@title)
          slug = [title_slug, file_slug(match)].join('-')
          href = File.join(CGI.escape(WIKI_TOKEN), 'wiki', slug)
          %(<a href="#{href}" title="#{$1}">#{$1}</a>)
        end
        page
      end
    end

    def create_module_meta_item_elements(item_node)
      item_node.content_type 'WikiPage'
      item_node.identifierref @identifier
    end
  end
end
