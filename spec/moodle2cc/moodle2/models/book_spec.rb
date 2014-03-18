require 'spec_helper'

describe Moodle2CC::Moodle2::Models::Book do
  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :module_id
  it_behaves_like 'it has an attribute for', :name
  it_behaves_like 'it has an attribute for', :intro
  it_behaves_like 'it has an attribute for', :intro_format
  it_behaves_like 'it has an attribute for', :numbering
  it_behaves_like 'it has an attribute for', :custom_titles
  it_behaves_like 'it has an attribute for', :chapters, []
end