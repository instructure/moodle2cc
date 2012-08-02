module Moodle2CC::Moodle
  class Section
    include HappyMapper

    attr_accessor :course

    class Mod
      include HappyMapper

      attr_accessor :section, :instance

      tag 'MODS/MOD'

      element :id, Integer, :tag => 'ID'
      element :instance_id, Integer, :tag => 'INSTANCE'
      element :mod_type, String, :tag => 'TYPE'
      element :added, Integer, :tag => 'ADDED'
      element :indent, Integer, :tag => 'INDENT'
      element :visible, Boolean, :tag => 'VISIBLE'

      def instance
        return @instance if @instance
        @instance = section.course.mods.find { |mod| mod.id == instance_id && mod.mod_type == mod_type }
      end
    end

    tag 'SECTIONS/SECTION'
    element :id, Integer, :tag => 'ID'
    element :number, Integer, :tag => 'NUMBER'
    element :summary, String, :tag => 'SUMMARY'
    element :visible, Boolean, :tag => 'VISIBLE'
    has_many :mods, Mod

    after_parse do |section|
      mod = Mod.new
      mod.id = "section_summary_mod_#{section.id}"
      mod.instance_id = "section_summary_instance_#{section.id}"
      mod.mod_type = 'summary'
      mod.indent = 0
      mod.visible = true

      instance = Moodle2CC::Moodle::Mod.new
      instance.id = "section_summary_instance_#{section.id}"
      instance.mod_type = 'summary'
      html = Nokogiri::HTML(section.summary)
      html.search('style').each(&:unlink)
      instance.name = html.text.strip
      instance.name = "#{instance.name[0..50]}..." if instance.name.length > 50
      instance.content = section.summary

      if instance.content && instance.content.length > 0
        mod.instance = instance
        section.mods.unshift mod
      end

      section.mods.each { |mod| mod.section = section }
    end
  end
end
