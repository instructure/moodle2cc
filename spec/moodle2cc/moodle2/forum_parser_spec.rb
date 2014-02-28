require 'spec_helper'

describe Moodle2CC::Moodle2::ForumParser do
  subject(:parser) { Moodle2CC::Moodle2::ForumParser.new(fixture_path(File.join('moodle2', 'backup')))}


  it 'parses a moodle forum' do
    forums = parser.parse
    expect(forums.count).to eq 1
    forum = forums.first
    expect(forum.id).to eq '1'
    expect(forum.module_id).to eq '1'
    expect(forum.type).to eq 'news'
    expect(forum.name).to eq 'News forum'
    expect(forum.intro).to eq 'General news and announcements'
    expect(forum.intro_format).to eq '1'
    expect(forum.assessed).to eq '0'
    expect(forum.assess_time_start).to eq '0'
    expect(forum.assess_time_finish).to eq '0'
    expect(forum.scale).to eq '0'
    expect(forum.max_bytes).to eq '0'
    expect(forum.max_attachments).to eq '1'
    expect(forum.force_subsscribe).to eq '1'
    expect(forum.tracking_type).to eq '1'
    expect(forum.rss_type).to eq '0'
    expect(forum.rss_articles).to eq '0'
    expect(forum.time_modified).to eq '1392409402'
    expect(forum.warn_after).to eq '0'
    expect(forum.block_after).to eq '0'
    expect(forum.block_period).to eq '0'
    expect(forum.completion_discussions).to eq '0'
    expect(forum.completion_replies).to eq '0'
    expect(forum.completion_posts).to eq '0'
  end


end