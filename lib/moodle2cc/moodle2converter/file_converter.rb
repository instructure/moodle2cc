module Moodle2CC::Moodle2Converter
  class FileConverter
    include ConverterHelper

    def convert(moodle_file)
      canvas_file = Moodle2CC::CanvasCC::Models::CanvasFile.new

      unique_id = moodle_file.content_hash
      # we probably shouldn't have been using these as identifiers but if we change it now we'll break updates on re-import

      id_set = Migrator.unique_id_set
      if id_set.include?(unique_id)
        original_id = unique_id
        index = 0
        while id_set.include?(unique_id)
          index += 1
          unique_id = "#{original_id}#{index}"
        end
      end
      id_set << unique_id

      canvas_file.identifier = unique_id
      canvas_file.file_path = moodle_file.file_path + moodle_file.file_name
      canvas_file.file_location = moodle_file.file_location
      canvas_file
    end

  end
end