require 'spec_helper'

describe Moodle2CC::CanvasCC::DiscussionWriter do
  subject(:writer) { Moodle2CC::CanvasCC::DiscussionWriter.new(work_dir, discussion) }
  let(:work_dir) { Dir.mktmpdir }
  let(:discussion) {Moodle2CC::CanvasCC::Models::Discussion.new}

  after(:each) do
    FileUtils.rm_r work_dir
  end

  it 'creates the discussion xml' do
    discussion.identifier = 'discussion_id'
    discussion.title = 'Discussion Title'
    discussion.text = '<p>discussion_text</p>'
    writer.write
    xml = Nokogiri::XML(File.read(File.join(work_dir, discussion.discussion_resource.files.first)))
    expect(xml.%('topic/title').text).to eq 'Discussion Title'
    expect(xml.%('topic/text').text).to eq '<p>discussion_text</p>'
    expect(xml.at_xpath('xmlns:topic/xmlns:text/@texttype').value).to eq('text/html')
  end

  it 'creates the meta xml' do
    discussion.identifier = 'discussion_id'
    discussion.title = 'Discussion Title'
    discussion.text = '<p>discussion_text</p>'
    discussion.discussion_type = 'threaded'
    writer.write
    xml = Nokogiri::XML(File.read(File.join(work_dir, discussion.meta_resource.href)))
    expect(xml.at_xpath('xmlns:topicMeta/@identifier').value).to eq('discussion_id_meta')
    expect(xml.%('topicMeta/topic_id').text).to eq 'discussion_id'
    expect(xml.%('topicMeta/title').text).to eq 'Discussion Title'
    expect(xml.%('topicMeta/type').text).to eq 'topic'
    expect(xml.%('topicMeta/position').text).to eq ''
    expect(xml.%('topicMeta/discussion_type').text).to eq 'threaded'
  end

end