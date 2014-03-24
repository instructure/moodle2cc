module Moodle2CC::Moodle2::Parsers
  class GlossaryParser
    include ParserHelper

    GLOSSARY_XML = 'glossary.xml'
    GLOSSARY_MODULE_NAME = 'glossary'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, GLOSSARY_MODULE_NAME)
      activity_dirs.map { |dir| parse_glossary(dir) }
    end

    private

    def parse_glossary(glossary_dir)
      glossary = Moodle2CC::Moodle2::Models::Glossary.new
      File.open(File.join(@backup_dir, glossary_dir, GLOSSARY_XML)) do |f|
        glossary_xml = Nokogiri::XML(f)
        glossary.id = glossary_xml.at_xpath('/activity/glossary/@id').value
        glossary.module_id = glossary_xml.at_xpath('/activity/@moduleid').value
        glossary.name = parse_text(glossary_xml, '/activity/glossary/name')
        glossary.intro = parse_text(glossary_xml, '/activity/glossary/intro')
        glossary.intro_format = parse_text(glossary_xml, '/activity/glossary/introformat')
        glossary.allow_duplicated_entries = parse_text(glossary_xml, '/activity/glossary/allowduplicatedentries')
        glossary.display_format = parse_text(glossary_xml, '/activity/glossary/displayformat')
        glossary.main_glossary = parse_text(glossary_xml, '/activity/glossary/mainglossary')
        glossary.show_special = parse_text(glossary_xml, '/activity/glossary/showspecial')
        glossary.show_alphabet = parse_text(glossary_xml, '/activity/glossary/showalphabet')
        glossary.show_all = parse_text(glossary_xml, '/activity/glossary/showall')
        glossary.allow_comments = parse_text(glossary_xml, '/activity/glossary/allowcomments')
        glossary.allow_printview = parse_text(glossary_xml, '/activity/glossary/allowprintview')
        glossary.use_dynalink = parse_text(glossary_xml, '/activity/glossary/usedynalink')
        glossary.default_approval = parse_text(glossary_xml, '/activity/glossary/defaultapproval')
        glossary.global_glossary = parse_text(glossary_xml, '/activity/glossary/globalglossary')
        glossary.ent_by_page = parse_text(glossary_xml, '/activity/glossary/entbypage')
        glossary.edit_always = parse_text(glossary_xml, '/activity/glossary/editalways')
        glossary.rss_type = parse_text(glossary_xml, '/activity/glossary/rsstype')
        glossary.rss_articles = parse_text(glossary_xml, '/activity/glossary/rssarticles')
        glossary.assessed = parse_text(glossary_xml, '/activity/glossary/assessed')
        glossary.assess_time_start = parse_text(glossary_xml, '/activity/glossary/assesstimestart')
        glossary.assess_time_finish = parse_text(glossary_xml, '/activity/glossary/assesstimefinish')
        glossary.scale = parse_text(glossary_xml, '/activity/glossary/scale')
        glossary.completion_entries = parse_text(glossary_xml, '/activity/glossary/completionentries')
        glossary.entries += parse_glossary_entry(glossary_xml.search('/activity/glossary/entries/entry'))
      end
      glossary
    end

    def parse_glossary_entry(entry_nodes)
      entry_nodes.map do |node|
        entry = Moodle2CC::Moodle2::Models::GlossaryEntry.new
        entry.id = node.at_xpath('@id').value
        entry.user_id = parse_text(node, 'userid')
        entry.concept = parse_text(node, 'concept')
        entry.definition = parse_text(node, 'definition')
        entry.definition_format = parse_text(node, 'definitionformat')
        entry.definition_trust = parse_text(node, 'definitiontrust')
        entry.attachment = parse_text(node, 'attachment')
        entry.teacher_entry = parse_text(node, 'teacherentry')
        entry.source_glossary_id = parse_text(node, 'sourceglossaryid')
        entry.use_dynalink = parse_text(node, 'usedynalink')
        entry.case_sensitive = parse_text(node, 'casesensitive')
        entry.full_match = parse_text(node, 'fullmatch')
        entry.approved = parse_text(node, 'approved')

        entry
      end
    end

  end
end