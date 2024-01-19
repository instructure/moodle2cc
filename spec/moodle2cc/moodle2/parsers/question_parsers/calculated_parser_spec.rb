require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::CalculatedParser do
    xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))

    let(:calculated_node) do
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "1"]')
    end

    let(:calculatedmulti_node) do
      xml.at_xpath('/question_categories/question_category[@id = "?"]/question_bank_entries/question_bank_entry[@id = 1]/question_version/question_versions/questions/question[@id = "2"]')
    end

    let(:calculatedsimple_node) do
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "3"]')
    end


    it 'parses a calculated question' do
      question = subject.parse_question(calculated_node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::CalculatedQuestion)).to be_truthy
      expect(question.qtype).to eq 'calculated'
      expect(question.answers.count).to eq 1
      expect(question.answers.first.answer_text).to eq '{A}*{B}'
      expect(question.answers.first.fraction).to eq 1

      expect(question.correct_answer_format).to eq '1'
      expect(question.correct_answer_length).to eq '2'
      expect(question.tolerance).to eq '0.01'

      expect(question.dataset_definitions.count).to eq 2
      var1 = question.dataset_definitions[0]
      expect(var1[:name]).to eq 'A'
      expect(var1[:options]).to eq 'uniform:1:10:1'
      var2 = question.dataset_definitions[1]
      expect(var2[:name]).to eq 'B'
      expect(var2[:options]).to eq 'uniform:1:10:1'

      expect(question.var_sets.count).to eq 1
      set = question.var_sets.first
      expect(set[:ident]).to eq '1'
      expect(set[:vars]["A"]).to eq "3.5"
      expect(set[:vars]["B"]).to eq "3.1"
    end

    it 'parses a calculated multiple choice question into a standard calculated question' do
      question = subject.parse_question(calculatedmulti_node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::CalculatedQuestion)).to be_truthy
      expect(question.qtype).to eq 'calculatedmulti'
      expect(question.answers.count).to eq 1
      expect(question.answers.first.answer_text).to eq '{A}*{B}'
      expect(question.answers.first.fraction).to eq 1

      expect(question.correct_answer_format).to eq '1'
      expect(question.correct_answer_length).to eq '2'
      expect(question.tolerance).to eq '0.01'

      expect(question.dataset_definitions.count).to eq 2
      var1 = question.dataset_definitions[0]
      expect(var1[:name]).to eq 'A'
      expect(var1[:options]).to eq 'uniform:1:10:1'
      var2 = question.dataset_definitions[1]
      expect(var2[:name]).to eq 'B'
      expect(var2[:options]).to eq 'uniform:1:10:1'

      expect(question.var_sets.count).to eq 1
      set = question.var_sets.first
      expect(set[:ident]).to eq '1'
      expect(set[:vars]["A"]).to eq "5.1"
      expect(set[:vars]["B"]).to eq "7.1"
    end

    it 'parses a calculated simple question' do
      question = subject.parse_question(calculatedsimple_node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::CalculatedQuestion)).to be_truthy
      expect(question.qtype).to eq 'calculatedsimple'
      expect(question.answers.count).to eq 1

      expect(question.answers.first.answer_text).to eq '{A}*{A}'
      expect(question.answers.first.fraction).to eq 1

      expect(question.correct_answer_format).to eq '1'
      expect(question.correct_answer_length).to eq '2'
      expect(question.tolerance).to eq '0.01'

      expect(question.dataset_definitions.count).to eq 1
      var = question.dataset_definitions.first
      expect(var[:name]).to eq 'A'
      expect(var[:options]).to eq 'uniform:1.0:10.0:1'

      expect(question.var_sets.count).to eq 1
      set = question.var_sets.first
      expect(set[:ident]).to eq '1'
      expect(set[:vars]["A"]).to eq "3.6"
    end
  end
end
