module Moodle2CC::Moodle2Converter
  class WikiConverter
    include ConverterHelper

    def convert(moodle_wiki)
      canvas_pages = []

      moodle_wiki.pages.each do |moodle_page|
        canvas_page = Moodle2CC::CanvasCC::Models::Page.new
        canvas_page.identifier = generate_unique_identifier_for("#{moodle_wiki.id}#{moodle_page[:id]}") + PAGE_SUFFIX
        canvas_page.page_name = truncate_text(moodle_page[:title])
        canvas_page.workflow_state = workflow_state(moodle_wiki.visible)
        canvas_page.editing_roles = 'teachers'
        canvas_page.body = moodle_page[:content]
        canvas_pages << canvas_page
      end

      if moodle_wiki.first_page_title.to_s.strip.length > 0 &&
        (first_page = canvas_pages.detect{|page| page.title.to_s.strip == moodle_wiki.first_page_title.to_s.strip})
        first_page.identifier = generate_unique_identifier_for_activity(moodle_wiki)
        first_page.body = moodle_wiki.intro.to_s + first_page.body.to_s
        first_page.page_name = moodle_wiki.name
      else
        first_page = Moodle2CC::CanvasCC::Models::Page.new
        first_page.identifier = generate_unique_identifier_for_activity(moodle_wiki)
        first_page.body = moodle_wiki.intro
        first_page.workflow_state = workflow_state(moodle_wiki.visible)
        first_page.editing_roles = 'teachers'
        first_page.page_name = moodle_wiki.name
        canvas_pages << first_page
      end

      canvas_pages
    end

  end
end