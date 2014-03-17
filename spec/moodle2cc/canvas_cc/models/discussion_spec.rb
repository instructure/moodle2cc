require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe Discussion do

    it_behaves_like 'it has an attribute for', :title
    it_behaves_like 'it has an attribute for', :text
    it_behaves_like 'it has an attribute for', :discussion_type
    it_behaves_like 'it has an attribute for', :identifier

    it 'creates resource' do
      subject.stub(:discussion_resource) { :discussion_resource }
      subject.stub(:meta_resource) { :meta_resource }
      expect(subject.resources).to eq [:discussion_resource, :meta_resource]
    end

    it 'generates a discussion resource' do
      subject.identifier = 3
      subject.discussion_type = 'threaded'
      subject.title = 'discussion title'
      subject.text = 'discussion body'
      discussion_resource = subject.discussion_resource
      expect(discussion_resource).to be_a_kind_of Resource
      expect(discussion_resource.dependencies.count).to eq 1
      expect(discussion_resource.identifier).to eq 'CC_eccbc87e4b5ce2fe28308fd9f2a7baf3_DISCUSSION'
      expect(discussion_resource.dependencies.first).to eq 'CC_eccbc87e4b5ce2fe28308fd9f2a7baf3_DISCUSSION_META'
      expect(discussion_resource.type).to eq 'imsdt_xmlv1p1'
      expect(discussion_resource.files.count).to eq 1
      expect(discussion_resource.files.first).to eq 'CC_eccbc87e4b5ce2fe28308fd9f2a7baf3_DISCUSSION.xml'
    end

    it 'generates a meta resource' do
      subject.identifier = 3
      subject.discussion_type = 'threaded'
      subject.title = 'discussion title'
      subject.text = 'discussion body'
      meta_resource = subject.meta_resource
      expect(meta_resource).to be_a_kind_of Resource
      expect(meta_resource.type).to eq('associatedcontent/imscc_xmlv1p1/learning-application-resource')
      expect(meta_resource.href).to eq('CC_eccbc87e4b5ce2fe28308fd9f2a7baf3_DISCUSSION_META.xml')
      expect(meta_resource.files.count).to eq 1
      expect(meta_resource.files.first).to eq 'CC_eccbc87e4b5ce2fe28308fd9f2a7baf3_DISCUSSION_META.xml'
    end

  end
end