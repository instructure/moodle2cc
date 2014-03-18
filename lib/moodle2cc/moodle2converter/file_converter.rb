module Moodle2CC::Moodle2Converter
  class FileConverter
    include ConverterHelper

    def convert(moodle_file)
      canvas_file = Moodle2CC::CanvasCC::Models::CanvasFile.new
      canvas_file.identifier = generate_unique_identifier_for(moodle_file.content_hash, FILE_SUFFIX)
      canvas_file.file_path = moodle_file.file_path + moodle_file.file_name
      canvas_file.file_location = moodle_file.file_location
      canvas_file
    end

  end
end