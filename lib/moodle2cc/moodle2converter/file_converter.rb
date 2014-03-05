module Moodle2CC::Moodle2Converter
  class FileConverter

    def convert(moodle_file)
      canvas_file = Moodle2CC::CanvasCC::Model::CanvasFile.new
      canvas_file.identifier = moodle_file.id
      canvas_file.file_path = moodle_file.file_name
      canvas_file.file_location = moodle_file.file_location
      canvas_file
    end

  end
end