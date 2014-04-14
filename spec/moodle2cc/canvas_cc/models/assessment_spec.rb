require 'spec_helper'

describe Moodle2CC::CanvasCC::Models::Assessment do

  it_behaves_like 'it has an attribute for', :identifier
  it_behaves_like 'it has an attribute for', :title
  it_behaves_like 'it has an attribute for', :description
  it_behaves_like 'it has an attribute for', :lock_at
  it_behaves_like 'it has an attribute for', :unlock_at
  it_behaves_like 'it has an attribute for', :allowed_attempts
  it_behaves_like 'it has an attribute for', :scoring_policy
  it_behaves_like 'it has an attribute for', :access_code
  it_behaves_like 'it has an attribute for', :ip_filter
  it_behaves_like 'it has an attribute for', :shuffle_answers
  it_behaves_like 'it has an attribute for', :time_limit
  it_behaves_like 'it has an attribute for', :quiz_type
  it_behaves_like 'it has an attribute for', :workflow_state

  it_behaves_like 'it has an attribute for', :question_references, []
  it_behaves_like 'it has an attribute for', :items

  it 'creates a resource' do
    subject.stub(:assessment_resource) {:assessment_resource}
    expect(subject.resources).to eq [:assessment_resource]
  end

  it 'generates an assessment resource' do
    subject.identifier = 'assessment_id'
    subject.title = 'My Assessment'

    resource = subject.assessment_resource
    expect(resource).to be_a_kind_of Moodle2CC::CanvasCC::Models::Resource
    expect(resource.files.count).to eq 2
    expect(resource.identifier).to eq 'assessment_id'
    expect(resource.type).to eq 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    expect(resource.href).to eq 'assessment_id/assessment_meta.xml'
    expect(resource.files).to include 'assessment_id/assessment_meta.xml'
    expect(resource.files).to include 'non_cc_assessments/assessment_id.xml.qti'
  end

  it 'resolves assessment questions' do
    subject.question_references = [
      {:question => '1', :grade => '2'},
      {:question => '2', :grade => '3'},
      {:question => '3', :grade => '5'},
      {:question => 'grouppy', :grade => '8.0'},
      {:question => 'nonexistent', :grade => '4'}
    ]

    qb1 = Moodle2CC::CanvasCC::Models::QuestionBank.new
    q1 = Moodle2CC::CanvasCC::Models::Question.new
    q1.original_identifier = '1'
    q2 = Moodle2CC::CanvasCC::Models::Question.new
    q2.original_identifier = '3'
    qb1.questions = [q1, q2]

    qb2 = Moodle2CC::CanvasCC::Models::QuestionBank.new
    q3 = Moodle2CC::CanvasCC::Models::Question.new
    q3.original_identifier = '2'
    qb2.questions = [q3]

    group = Moodle2CC::CanvasCC::Models::QuestionGroup.new
    group.selection_number = 4
    group.identifier = 'grouppy'
    group.questions = [q2]
    qb2.question_groups = [group]

    subject.resolve_question_references([qb1, qb2])

    expect(subject.items.count).to eq 3
    expect(subject.items[0].points_possible).to eq '2'
    expect(subject.items[1].points_possible).to eq '3'
    # should not include q2 because it's already part of the group
    expect(subject.items[2].points_per_item).to eq 2
  end


end