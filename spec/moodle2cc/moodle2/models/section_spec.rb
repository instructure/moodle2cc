require 'spec_helper'

describe Moodle2CC::Moodle2::Model::Section do

  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :number
  it_behaves_like 'it has an attribute for', :name
  it_behaves_like 'it has an attribute for', :summary
  it_behaves_like 'it has an attribute for', :summary_format
  it_behaves_like 'it has an attribute for', :sequence
  it_behaves_like 'it has an attribute for', :visible
  it_behaves_like 'it has an attribute for', :available_from
  it_behaves_like 'it has an attribute for', :available_until
  it_behaves_like 'it has an attribute for', :release_code
  it_behaves_like 'it has an attribute for', :show_availability
  it_behaves_like 'it has an attribute for', :grouping_id
  it_behaves_like 'it has an attribute for', :position
  it_behaves_like 'it has an attribute for', :activities, []

end