module Moodle2CC
  module Moodle2Converter::ConverterHelper
    def update_links(content)
      return unless content
      content.gsub('@@PLUGINFILE@@', '%24IMS_CC_FILEBASE%24')
    end
  end
end
