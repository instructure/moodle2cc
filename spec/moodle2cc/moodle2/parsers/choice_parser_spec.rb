require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::ChoiceParser do
  subject { Moodle2CC::Moodle2::Parsers::ChoiceParser.new(fixture_path(File.join('moodle2', 'backup'))) }

  it 'should parse a choice activity' do
    choices = subject.parse
    expect(choices.count).to eq 1
    choice = choices.first

    expect(choice.id).to eq '1'

    expect(choice.module_id).to eq '56547'
    expect(choice.name).to eq 'Example Choice Activity'
    expect(choice.intro).to eq 'Choice activity description'
    expect(choice.intro_format).to eq '1'
    expect(choice.time_open).to eq '0'
    expect(choice.time_close).to eq '0'
    expect(choice.time_modified).to eq '1376437841'

    expect(choice.publish).to eq '0'
    expect(choice.show_results).to eq '0'
    expect(choice.display).to eq '1'
    expect(choice.allow_update).to eq '1'
    expect(choice.show_unanswered).to eq '1'
    expect(choice.limit_answers).to eq '1'
    expect(choice.completion_submit).to eq '0'

    expect(choice.options).to eq ['Option 1', 'Option 2']
  end

end