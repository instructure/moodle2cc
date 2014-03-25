require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::FolderConverter do

    let(:moodle2_folder) { Moodle2::Models::Folder.new }
    let(:moodle2_course) { Moodle2::Models::Course.new }

    before(:each) do
      files = 4.times.map do |i|
        f = Moodle2::Models::Moodle2File.new
        f.id = "#{i+1}"
        f.file_name = "file#{i+1}.txt"
        f.file_path = "/"
        f
      end
      files[2].file_path = '/subfolder1/subfolder2/'
      files[3].file_path = '/subfolder1/'
      moodle2_folder.file_ids = ['1', '2', '3', '4']
      moodle2_course.files += files
    end

    subject { Moodle2Converter::FolderConverter.new(moodle2_course) }

    it 'converts a moodle folder to a canvas page' do
      moodle2_folder.id = '3'
      moodle2_folder.name = 'Folder Name'
      canvas_page = subject.convert(moodle2_folder)
      expect(canvas_page.identifier).to eq 'm2eccbc87e4b5ce2fe28308fd9f2a7baf3_folder'
      expect(canvas_page.title).to eq 'Folder Name'
      expect(canvas_page.workflow_state).to eq('active')
      expect(canvas_page.editing_roles).to eq('teachers')
      expect(canvas_page.body).to include('ul')
      expect(canvas_page.body).to include('<li><p><a href="@@PLUGINFILE@@/file1.txt">file1.txt</a></p></li>')
      expect(canvas_page.body).to include('<li><p><a href="@@PLUGINFILE@@/file2.txt">file2.txt</a></p></li>')
      expect(canvas_page.body).to include('<li><p><a href="@@PLUGINFILE@@/subfolder1/file4.txt">subfolder1/file4.txt</a></p></li>')
      expect(canvas_page.body).to include('<li><p><a href="@@PLUGINFILE@@/subfolder1/subfolder2/file3.txt">subfolder1/subfolder2/file3.txt</a></p></li>')
    end

  end
end