module Moodle2CC::Moodle2::Models
  class Wiki

    attr_accessor :id, :module_id, :name, :intro, :intro_format, :visible, :first_page_title, :pages

    def initialize
      @pages = []
    end
  end
end