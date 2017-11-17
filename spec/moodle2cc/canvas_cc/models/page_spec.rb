require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe Page do
    subject(:page) { Page.new }

    it_behaves_like 'a Moodle2CC::CanvasCC::Models::Resource'

    it_behaves_like 'it has an attribute for', :workflow_state
    it_behaves_like 'it has an attribute for', :editing_roles
    it_behaves_like 'it has an attribute for', :body
    it_behaves_like 'it has an attribute for', :title

    describe '#type' do
      subject { super().type }
      it { is_expected.to eq 'webcontent' }
    end

    it "hashes the identifier" do
      page.identifier = 3
      expect(page.identifier).to eq 3
    end

    it "sets the title" do
      page.page_name = 'My Page Name'
      expect(page.title).to eq 'My Page Name'
    end

    it "converts names to urls" do
      expect(page.class.convert_name_to_url('My Page Name')).to eq 'my-page-name'
    end

    it "truncates urls that are too long" do
      expected = "#{'a' * Moodle2CC::CanvasCC::Models::Page::MAX_URL_LENGTH}"
      expect(page.class.convert_name_to_url('a' * 500)).to eq expected
    end

  end
end