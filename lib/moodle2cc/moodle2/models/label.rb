module Moodle2CC::Moodle2::Models
  class Label
    attr_accessor :id, :module_id, :name, :intro, :intro_format, :visible

    DEFAULT_PAGE_TITLE = "Untitled Page"

    def name_text
      @name_text ||= (Nokogiri::HTML(@name.to_s).text.strip rescue "")
    end

    def intro_html
      @intro_html ||= (Nokogiri::HTML(@intro.to_s) rescue Nokogiri::HTML(''))
    end

    def intro_text
      @intro_text ||= (intro_html.text.strip rescue "")
    end

    def converted_title
      process_for_conversion!
      @converted_title
    end

    def convert_to_page?
      process_for_conversion!
      @convert_to_page
    end

    def convert_to_header?
      process_for_conversion!
      @convert_to_header
    end


    def process_for_conversion!
      return unless @converted_title.nil? || @convert_to_page.nil? || @convert_to_header.nil?

      @converted_title = name_text

      if @converted_title == "Label" || @converted_title.end_with?("...") || @converted_title.length == 0
        if intro_text.length > 80

          @converted_title = intro_text[0..79] + "..."
          @convert_to_page = true
        else
          if intro_text.length > 0
            @converted_title = intro_text
          else
            @converted_title = DEFAULT_PAGE_TITLE
            @convert_to_header = false # if we're not going to convert it to a page, don't convert it at all
          end
        end
      end

      # if the intro has no text or the text is identical, then convert to page if it has tags
      if @converted_title == intro_text || intro_text.length == 0
        @convert_to_page = intro_html.search('img[src]').length > 0 ||
            intro_html.search('a[href]').length > 0 ||
            intro_html.search('iframe[src]').length > 0
      elsif intro_text.length > 0
        @convert_to_page = true
      else
        @convert_to_page = false
      end

      # do the opposite if we haven't already explicitly decided not to convert to a header
      if @convert_to_header.nil?
        @convert_to_header = !@convert_to_page
      end
    end
  end
end