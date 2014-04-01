require 'spec_helper'

describe Moodle2CC::Moodle2::Models::Page do

  it_behaves_like 'it has an attribute for', :module_id
  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :name
  it_behaves_like 'it has an attribute for', :intro
  it_behaves_like 'it has an attribute for', :intro_format
  it_behaves_like 'it has an attribute for', :content
  it_behaves_like 'it has an attribute for', :content_format
  it_behaves_like 'it has an attribute for', :legacy_files
  it_behaves_like 'it has an attribute for', :legacy_files_last
  it_behaves_like 'it has an attribute for', :display
  it_behaves_like 'it has an attribute for', :display_options
  it_behaves_like 'it has an attribute for', :revision
  it_behaves_like 'it has an attribute for', :time_modified
  it_behaves_like 'it has an attribute for', :visible




end