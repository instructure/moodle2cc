require 'spec_helper'

describe Moodle2CC::CanvasCC::Models::CalculatedQuestion do

  context '#post_process!' do
    it 'should replace {variables} with [variables] in material' do
      subject.material = "{varname} {not * s valid var name and stuff}"

      subject.post_process!

      expect(subject.material).to eq "[varname] {not * s valid var name and stuff}"
    end

    it 'should replace {variables} with variables in formulae (and strip =)' do
      answer = Moodle2CC::CanvasCC::Models::Answer.new
      answer.answer_text = "={A}*{B}"
      subject.answers = [answer]

      subject.post_process!

      expect(subject.answers.first.answer_text).to eq "A*B"
    end
  end

end