require 'spec_helper'

module Moodle2CC::Moodle2Converter
describe DiscussionConverter do
  let(:forum){Moodle2CC::Moodle2::Models::Forum.new}

    it 'converts a moodle forum to a canvas discussion' do
      forum.id = '3'
      forum.name = 'Forum Name'
      forum.intro = 'Forum Introduction'
      forum.visible = false
      forum.type = 'qanda'

      discussion = subject.convert(forum)

      expect(discussion.identifier).to eq 'm2eccbc87e4b5ce2fe28308fd9f2a7baf3_discussion'
      expect(discussion.title).to eq 'Forum Name'
      expect(discussion.text).to eq 'Forum Introduction'
      expect(discussion.discussion_type).to eq 'threaded'
      expect(discussion.workflow_state).to eq 'unpublished'
      expect(discussion.require_initial_post).to eq true

      forum.type = 'general'
      discussion2 = subject.convert(forum)
      expect(discussion2.require_initial_post).to eq false
    end
  end
end