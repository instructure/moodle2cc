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

  it 'returns both resources' do
    allow(subject).to receive(:cc_assessment_resource) {:cc_resource}
    allow(subject).to receive(:canvas_assessment_resource) {:canvas_resource}
    expect(subject.resources).to eq [:cc_resource, :canvas_resource]
  end

  it 'creates resources' do
    subject.identifier = 'assessment_id'
    subject.title = 'My Assessment'

    cc_resource = subject.cc_assessment_resource
    expect(cc_resource).to be_a_kind_of Moodle2CC::CanvasCC::Models::Resource
    expect(cc_resource.type).to eq 'imsqti_xmlv1p2/imscc_xmlv1p1/assessment'
    expect(cc_resource.identifier).to eq 'assessment_id'
    expect(cc_resource.dependencies).to include 'assessment_id_meta'

    canvas_resource = subject.canvas_assessment_resource
    expect(canvas_resource).to be_a_kind_of Moodle2CC::CanvasCC::Models::Resource
    expect(canvas_resource.files.count).to eq 2
    expect(canvas_resource.identifier).to eq 'assessment_id_meta'
    expect(canvas_resource.type).to eq 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    expect(canvas_resource.href).to eq 'assessment_id/assessment_meta.xml'
    expect(canvas_resource.files).to include 'assessment_id/assessment_meta.xml'
    expect(canvas_resource.files).to include 'non_cc_assessments/assessment_id.xml.qti'
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

    subject.resolve_question_references!([qb1, qb2])

    expect(subject.items.count).to eq 3
    expect(subject.items[0].points_possible).to eq '2'
    expect(subject.items[1].points_possible).to eq '3'
    # should not include q2 because it's already part of the group
    expect(subject.items[2].points_per_item).to eq 2
  end


  it 'resolves random quesiton references' do
    subject.question_references = [
        {:question => 'random1', :grade => '2'},
        {:question => 'random2', :grade => '3'},
        {:question => 'random3', :grade => '3'},
        {:question => 'nonexistent', :grade => '4'}
    ]

    qb1 = Moodle2CC::CanvasCC::Models::QuestionBank.new
    q1 = Moodle2CC::CanvasCC::Models::Question.new
    q1.identifier = '1'
    q2 = Moodle2CC::CanvasCC::Models::Question.new
    q2.identifier = '2'

    qb1.questions = [q1, q2]
    qb1.original_id = 'parent'
    qb1.random_question_references = ['random1', 'random2']

    qb2 = Moodle2CC::CanvasCC::Models::QuestionBank.new
    q3 = Moodle2CC::CanvasCC::Models::Question.new
    q3.identifier = '3'
    qb2.parent_id = 'parent'
    qb2.questions = [q3]

    qb3 = Moodle2CC::CanvasCC::Models::QuestionBank.new
    q4 = Moodle2CC::CanvasCC::Models::Question.new
    q4.identifier = '4'
    q5 = Moodle2CC::CanvasCC::Models::Question.new
    q5.identifier = '5'
    qb3.questions = [q4, q5]
    qb3.random_question_references = ['random3']

    subject.resolve_question_references!([qb1, qb2, qb3])

    expect(subject.items.count).to eq 2
    group1 = subject.items[0]
    expect(group1.class).to eq Moodle2CC::CanvasCC::Models::QuestionGroup
    expect(group1.selection_number).to eq 2
    expect(group1.questions.map(&:identifier)).to eq [q1, q2, q3].map(&:identifier)

    group2 = subject.items[1]
    expect(group2.class).to eq Moodle2CC::CanvasCC::Models::QuestionGroup
    expect(group2.selection_number).to eq 1
    expect(group2.questions.map(&:identifier)).to eq qb3.questions.map(&:identifier)
  end

end