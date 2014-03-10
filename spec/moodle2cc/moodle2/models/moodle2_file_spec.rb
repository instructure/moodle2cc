require 'spec_helper'

describe Moodle2CC::Moodle2::Model::Moodle2File do

  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :content_hash
  it_behaves_like 'it has an attribute for', :context_id
  it_behaves_like 'it has an attribute for', :component
  it_behaves_like 'it has an attribute for', :file_area
  it_behaves_like 'it has an attribute for', :item_id
  it_behaves_like 'it has an attribute for', :file_path
  it_behaves_like 'it has an attribute for', :file_name
  it_behaves_like 'it has an attribute for', :user_id
  it_behaves_like 'it has an attribute for', :mime_type
  it_behaves_like 'it has an attribute for', :status
  it_behaves_like 'it has an attribute for', :time_created
  it_behaves_like 'it has an attribute for', :time_modified
  it_behaves_like 'it has an attribute for', :source
  it_behaves_like 'it has an attribute for', :author
  it_behaves_like 'it has an attribute for', :license
  it_behaves_like 'it has an attribute for', :sort_order
  it_behaves_like 'it has an attribute for', :repository_type
  it_behaves_like 'it has an attribute for', :repository_id
  it_behaves_like 'it has an attribute for', :reference
  it_behaves_like 'it has an attribute for', :file_location

  it 'sets file size as int when passing in a string' do
    subject.file_size = "5"
    expect(subject.file_size).to eq(5)
  end

end