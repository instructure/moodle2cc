module Moodle2CC::Moodle2::Parsers
  class FeedbackParser
    include ParserHelper

    FEEDBACK_XML = 'feedback.xml'
    FEEDBACK_MODULE_NAME = 'feedback'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, FEEDBACK_MODULE_NAME)
      activity_dirs.map { |dir| parse_feedback(dir) }
    end

    private

    def parse_feedback(dir)
      feedback = Moodle2CC::Moodle2::Models::Feedback.new
      activity_dir = File.join(@backup_dir, dir)

      File.open(File.join(activity_dir, FEEDBACK_XML)) do |f|
        xml = Nokogiri::XML(f)
        feedback.id = xml.at_xpath('/activity/feedback/@id').value
        feedback.module_id = xml.at_xpath('/activity/@moduleid').value
        feedback.name = parse_text(xml, '/activity/feedback/name')
        feedback.intro = parse_text(xml, '/activity/feedback/intro')
        feedback.intro_format = parse_text(xml, '/activity/feedback/introformat')

        feedback.time_open = parse_text(xml, '/activity/feedback/timeopen')
        feedback.time_close = parse_text(xml, '/activity/feedback/timeclose')
        feedback.time_modified = parse_text(xml, '/activity/feedback/timemodified')

        xml.search('/activity/feedback/items/item').each do |node|
          item = Moodle2CC::Moodle2::Models::Feedback::Question.new
          item.id = node.attributes['id'].value
          item.name = parse_text(node, 'name')
          item.label = parse_text(node, 'label')
          item.type = parse_text(node, 'typ')
          item.position = parse_text(node, 'position')
          item.presentation = parse_text(node, 'presentation')

          feedback.items << item
        end
        feedback.items.sort_by!{|q| q.position.to_i}
      end
      parse_module(activity_dir, feedback)

      feedback
    end

  end
end