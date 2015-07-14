require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe QuestionConverter do

    class FooBarConverter < QuestionConverter
    end

    it 'registers a question type for conversion' do
      converter = FooBarConverter.new
      converter.stub(:convert_question)

      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.new
      moodle_question.type = 'foobar'

      FooBarConverter.stub(:new).and_return(converter)
      FooBarConverter.register_converter_type 'foobar'
      QuestionConverter.new.convert(moodle_question)
      expect(converter).to have_received(:convert_question)
    end

    it 'raises an exception for unknown converter types' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.new
      moodle_question.type = 'nonexistenttype'

      expect { QuestionConverter.new.convert(moodle_question) }.to raise_exception
    end

    it 'converts common question attributes' do
      converter = QuestionConverter.new
      mock_canvas_question = Moodle2CC::CanvasCC::Models::Question.new
      converter.stub(:create_canvas_question).and_return(mock_canvas_question)

      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.new
      moodle_question.id = 42
      moodle_question.name = 'has anyone really been far even as decided to use even go want to do look more like'
      answer = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      answer.id = 'blah'
      moodle_question.answers = [answer]
      moodle_question.max_mark = 2
      moodle_question.general_feedback = 'random stuff'
      moodle_question.question_text = 'other stuff'

      converted_question = converter.convert_question(moodle_question)

      expect(converted_question.original_identifier).to eq moodle_question.id
      expect(converted_question.title).to eq moodle_question.name
      expect(converted_question.answers.count).to eq moodle_question.answers.count
      expect(converted_question.answers.first.id).to eq moodle_question.answers.first.id
      expect(converted_question.general_feedback).to eq moodle_question.general_feedback
      expect(converted_question.points_possible).to eq moodle_question.max_mark
      expect(converted_question.material).to eq moodle_question.question_text
    end

    it 'converts markdown text in question to html material' do
      converter = QuestionConverter.new
      mock_canvas_question = Moodle2CC::CanvasCC::Models::Question.new
      converter.stub(:create_canvas_question).and_return(mock_canvas_question)

      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.new
      moodle_question.question_text = "This is **bold** and this is _italic_"
      moodle_question.question_text_format = 4 # markdown

      converted_question = converter.convert_question(moodle_question)

      expected_text = "<p>This is <strong>bold</strong> and this is <em>italic</em></p>\n"
      expect(converted_question.material).to eq expected_text
    end

    it 'converts standard questions' do
      converter = QuestionConverter.new

      converted_question = converter.convert(Moodle2CC::Moodle2::Models::Quizzes::Question.create('essay'))
      expect(converted_question.question_type).to eq 'essay_question'

      converted_question = converter.convert(Moodle2CC::Moodle2::Models::Quizzes::Question.create('shortanswer'))
      expect(converted_question.question_type).to eq 'short_answer_question'
    end

  end
end