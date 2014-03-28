require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::DiscussionConverter do
    let(:forum) { Moodle2::Model::Forum.new }

    it 'converts a moodle forum to a canvas discussion' do
      forum.id = '3'
      forum.name = 'Forum Name'
      forum.intro = 'Forum Introduction'
      forum.visible = false

      discussion = subject.convert(forum)

      expect(discussion.identifier).to eq 'm2eccbc87e4b5ce2fe28308fd9f2a7baf3_discussion'
      expect(discussion.title).to eq 'Forum Name'
      expect(discussion.text).to eq 'Forum Introduction'
      expect(discussion.discussion_type).to eq 'threaded'
      expect(discussion.workflow_state).to eq 'unpublished'

    end
  end
end