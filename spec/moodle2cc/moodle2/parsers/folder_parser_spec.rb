require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe FolderParser do

    subject { FolderParser.new(fixture_path(File.join('moodle2', 'backup'))) }

    it 'parses books' do
      folders = subject.parse
      expect(folders.count).to eq(1)

      folder = folders.first
      expect(folder.module_id).to eq('7')
      expect(folder.id).to eq('1')
      expect(folder.name).to eq('Folder Name')
      expect(folder.intro).to eq('<p>Folder Description</p>')
      expect(folder.intro_format).to eq('1')
      expect(folder.revision).to eq('1')
      expect(folder.file_ids).to eq(['29', '30', '31', '32', '33'])
    end

  end
end