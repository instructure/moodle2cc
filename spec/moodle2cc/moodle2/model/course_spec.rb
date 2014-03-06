require 'spec_helper'

describe Moodle2CC::Moodle2::Model::Course do

  it_behaves_like 'it has an attribute for', :id_number
  it_behaves_like 'it has an attribute for', :fullname
  it_behaves_like 'it has an attribute for', :shortname
  it_behaves_like 'it has an attribute for', :startdate
  it_behaves_like 'it has an attribute for', :summary
  it_behaves_like 'it has an attribute for', :course_id

end