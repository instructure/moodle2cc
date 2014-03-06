require 'spec_helper'

module Moodle2CC::Moodle2
  describe FileParser do

    it 'should parse files' do
      file_parser = FileParser.new(fixture_path(File.join('moodle2', 'backup')))
      files = file_parser.parse
      file = files[0]
      expect(file.id).to eq('15')
      expect(file.content_hash).to eq('a0f324310c8d8dd9c79458986c4322f5a060a1d9')
      expect(file.context_id).to eq('22')
      expect(file.component).to eq('mod_resource')
      expect(file.file_area).to eq('content')
      expect(file.item_id).to eq('0')
      expect(file.file_path).to eq('/')
      expect(file.file_name).to eq('smaple_gif.gif')
      expect(file.user_id).to eq('2')
      expect(file.file_size).to eq(2444236)
      expect(file.mime_type).to eq('image/gif')
      expect(file.status).to eq('0')
      expect(file.time_created).to eq('1392903875')
      expect(file.time_modified).to eq('1392903895')
      expect(file.source).to eq('Server files: Miscellaneous/Sample Course/My Sample Page (Page)/Page content/smaple_gif.gif')
      expect(file.author).to eq('Admin User')
      expect(file.license).to eq('allrightsreserved')
      expect(file.sort_order).to eq('1')
      expect(file.repository_type).to eq(nil)
      expect(file.repository_id).to eq(nil)
      expect(file.reference).to eq(nil)
      expect(file.file_location).to include('files/a0/a0f324310c8d8dd9c79458986c4322f5a060a1d9')
    end

  end
end