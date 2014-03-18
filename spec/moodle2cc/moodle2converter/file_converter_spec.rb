require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::FileConverter do

    it 'should convert a moodle file to a canvas file' do
      moodle_file = Moodle2::Model::Moodle2File.new
      moodle_file = Moodle2::Models::Moodle2File.new
      moodle_file.content_hash = 'abcde'
      moodle_file.file_location = 'path_to_file'
      moodle_file.file_name = 'my_file_name'
      moodle_file.id = 'my_file_id'
      canvas_file = subject.convert(moodle_file)
      expect(canvas_file.identifier).to eq('m2ab56b4d92b40713acc5af89985d4b786_file')
      expect(canvas_file.file_location).to eq('path_to_file')
      expect(canvas_file.file_path).to eq('my_file_name')
    end

  end
end