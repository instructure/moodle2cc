require 'spec_helper'

module Moodle2CC::CanvasCC::Model
  describe CanvasFile do

    it_behaves_like 'a Moodle2CC::CanvasCC::Model::Resource'
    it_behaves_like 'it has an attribute for', :file_location

    it 'has a type to webcontent' do
      expect(subject.type).to eq(Resource::WEB_CONTENT_TYPE)
    end

    it 'sets up href, file_path and files on #file_path=' do
      filename = 'myfile.txt'
      subject.file_path = filename
      expect(subject.href).to eq('web_resources/myfile.txt')
      expect(subject.file_path).to eq(filename)
      expect(subject.files.count).to eq(1)
      expect(subject.files.first).to eq('web_resources/myfile.txt')
    end

    it 'adds a postfix to the identifier on #identifier=' do
      subject.identifier = 'foo_bar'
      expect(subject.attributes[:identifier]).to eq('CC_5c7d96a3dd7a87850a2ef34087565a6e_FILE')
    end

  end
end
