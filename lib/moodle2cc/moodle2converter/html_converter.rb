module Moodle2CC::Moodle2Converter
  class HtmlConverter
    include ConverterHelper

    def initialize(canvas_course, moodle_files)
      @canvas_course = canvas_course
      canvas_files = @canvas_course.files
      @file_index = {}
      moodle_files.each do |f|
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
      html.css('a[href]').each {|tag| tag['href'] = update_url(tag.attr('href'))}
      html.css('link[href]').each {|tag| tag.remove}
      html.to_s
    end

    def update_url(link)
      if cc_file = lookup_cc_file(link)
        "%24IMS_CC_FILEBASE%24#{cc_file.file_path}"
      else
        link
      end
    end

    def lookup_cc_file(link)
      if match = link.match(/@@PLUGINFILE@@(.*)/)
        @file_index[CGI::unescape(match.captures.first)]
      end
    end

  end
end