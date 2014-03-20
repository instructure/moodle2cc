module Moodle2CC::Moodle2Converter
  class HtmlConverter
    include ConverterHelper

    OBJECT_TOKEN = "$CANVAS_OBJECT_REFERENCE$"
    COURSE_TOKEN = "$CANVAS_COURSE_REFERENCE$"
    WIKI_TOKEN = "$WIKI_REFERENCE$"
    WEB_CONTENT_TOKEN = "$IMS_CC_FILEBASE$"

    def initialize(canvas_course, moodle_course)
      @canvas_course = canvas_course
      @moodle_course = moodle_course
      canvas_files = @canvas_course.files
      @file_index = {}
      @moodle_course.files.each do |f|
        @file_index[f.file_path + f.file_name] = canvas_files.find { |cc_f| cc_f.identifier == f.content_hash }
      end
    end

    def convert(content)
      update_links(content.gsub('id="main"', ''))
    end

    private

    def update_links(content)
      html = Nokogiri::HTML.fragment(content)
      html.css('img').each { |img| img['src'] = update_url(img.attr('src')) }
      html.css('a[href]').each { |tag| tag['href'] = update_url(tag.attr('href')) }
      html.css('link[href]').each { |tag| tag.remove }
      html.to_s
    end

    def update_url(link)
      if cc_file = lookup_cc_file(link)
        "#{WEB_CONTENT_TOKEN}#{cc_file.file_path}"
      elsif match = link.match(/\/mod\/(page|forum|assignment)\/view\.php\?.*id=(\d*)(#.*)?/)
        lookup_cc_link(match.captures[0], match.captures[1], match.captures[2]) || link
      else
        link
      end
    end

    def lookup_cc_file(link)
      if match = link.match(/@@PLUGINFILE@@(.*)/)
        @file_index[CGI::unescape(match.captures.first)]
      end
    end

    def lookup_cc_link(activity, id, anchor)
      case activity
        when 'assignment'
          if assignment = @moodle_course.assignments.find { |assignment| assignment.id == id }
            "#{OBJECT_TOKEN}/assignments/#{generate_unique_identifier_for_activity(assignment)}#{anchor}"
          end
        when 'page'
          if page = @moodle_course.pages.find { |page| page.id == id }
            "#{WIKI_TOKEN}/pages/#{page.name}#{anchor}"
          end
        when 'forum'
          if forum = @moodle_course.forums.find { |forum| forum.id == id }
            "#{OBJECT_TOKEN}/discussion_topics/#{generate_unique_identifier_for_activity(forum)}#{anchor}"
          end
        else
          puts "unknown activity to replace link for. activity:#{activity} id:#{id}"
      end
    end

  end
end