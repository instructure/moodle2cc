require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::QuestionnaireParser do
  subject { Moodle2CC::Moodle2::Parsers::QuestionnaireParser.new(fixture_path(File.join('moodle2', 'backup'))) }

  it 'should parse a questionnaire activity' do
    questionnaires = subject.parse
    expect(questionnaires.count).to eq 1
    questionnaire = questionnaires.first

    expect(questionnaire.id).to eq '1'

    expect(questionnaire.module_id).to eq '9'
    expect(questionnaire.name).to eq 'Questionnaire Name'
    expect(questionnaire.intro).to eq '<p>Sumary</p>'
    expect(questionnaire.intro_format).to eq '1'
    expect(questionnaire.open_date).to eq '0'
    expect(questionnaire.close_date).to eq '0'
    expect(questionnaire.time_modified).to eq '1395073600'

    expect(questionnaire.questions.count).to eq 10
    question = questionnaire.questions.first
    expect(question.id).to eq '1'
    expect(question.name).to eq 'Checkboxes Quesiton'
    expect(question.position).to eq '1'
    expect(question.type_id).to eq '5'

    expect(question.choices.count).to eq 3
    expect(question.choices.first).to eq ({:id => '1', :content => 'possible answer 1'})
  end

end