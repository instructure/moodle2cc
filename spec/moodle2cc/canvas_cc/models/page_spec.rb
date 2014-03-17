require 'spec_helper'

module Moodle2CC::CanvasCC::Model
  describe Page do
    subject(:page) { Page.new }

    it_behaves_like 'a Moodle2CC::CanvasCC::Model::Resource'

    it_behaves_like 'it has an attribute for', :workflow_state
    it_behaves_like 'it has an attribute for', :editing_roles
    it_behaves_like 'it has an attribute for', :body
    it_behaves_like 'it has an attribute for', :title

    its(:type) { should eq 'webcontent' }

    it "hashes the identifier" do
      page.identifier = 3
      expect(page.identifier).to eq 3
    end

    it "sets the wiki_dir, and title" do
      page.page_name = 'My Page Name'
      expect(page.href).to eq 'wiki_content/my-page-name.html'
      expect(page.title).to eq 'My Page Name'
    end

  end
end