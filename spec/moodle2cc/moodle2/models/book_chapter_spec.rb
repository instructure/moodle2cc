require 'spec_helper'

describe Moodle2CC::Moodle2::Models::BookChapter do
  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :pagenum
  it_behaves_like 'it has an attribute for', :subchapter
  it_behaves_like 'it has an attribute for', :title
  it_behaves_like 'it has an attribute for', :content
  it_behaves_like 'it has an attribute for', :content_format
  it_behaves_like 'it has an attribute for', :hidden
end