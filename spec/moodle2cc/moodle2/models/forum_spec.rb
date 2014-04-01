require 'spec_helper'

describe Moodle2CC::Moodle2::Models::Forum do

  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :module_id
  it_behaves_like 'it has an attribute for', :type
  it_behaves_like 'it has an attribute for', :name
  it_behaves_like 'it has an attribute for', :intro
  it_behaves_like 'it has an attribute for', :intro_format
  it_behaves_like 'it has an attribute for', :assessed
  it_behaves_like 'it has an attribute for', :assess_time_start
  it_behaves_like 'it has an attribute for', :assess_time_finish
  it_behaves_like 'it has an attribute for', :scale
  it_behaves_like 'it has an attribute for', :max_bytes
  it_behaves_like 'it has an attribute for', :max_attachments
  it_behaves_like 'it has an attribute for', :force_subsscribe
  it_behaves_like 'it has an attribute for', :tracking_type
  it_behaves_like 'it has an attribute for', :rss_type
  it_behaves_like 'it has an attribute for', :rss_articles
  it_behaves_like 'it has an attribute for', :time_modified
  it_behaves_like 'it has an attribute for', :warn_after
  it_behaves_like 'it has an attribute for', :block_after
  it_behaves_like 'it has an attribute for', :block_period
  it_behaves_like 'it has an attribute for', :completion_discussions
  it_behaves_like 'it has an attribute for', :completion_replies
  it_behaves_like 'it has an attribute for', :completion_posts
  it_behaves_like 'it has an attribute for', :visible

end