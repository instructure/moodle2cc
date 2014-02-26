require 'spec_helper'

describe Moodle2CC::CanvasCC::Model::Course do
  subject(:course) {Moodle2CC::CanvasCC::Model::Course.new}

  it_behaves_like 'it has an attribute for', :format
  it_behaves_like 'it has an attribute for', :copyright
  it_behaves_like 'it has an attribute for', :settings, {}
  it_behaves_like 'it has an attribute for', :resources, []
  it_behaves_like 'it has an attribute for', :canvas_modules, []
  it_behaves_like 'it has an attribute for', :files, []

  it 'hashes the identifier' do
    course.identifier = 'course_id'
    expect(course.identifier).to eq 'CC_ea134da7ce0152b54fb73853f6d62644'
  end

  it 'formats date strings' do
    course.start_at = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
    course.conclude_at = Time.parse('Sat, 10 Feb 2014 16:00:00 GMT')
    expect(course.start_at).to eq '2014-02-08T16:00:00'
    expect(course.conclude_at).to eq '2014-02-10T16:00:00'
  end

  it 'creates settings for unknown attributes' do
    course.title = 'course_title'
    expect(course.settings[:title]).to eq 'course_title'
  end

  describe '#all_resources' do
    it 'includes files and resources' do
      course.files << :foo
      course.resources << :bar
      expect(course.all_resources).to eq [:bar, :foo]
    end
  end

end