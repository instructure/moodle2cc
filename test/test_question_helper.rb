module TestQuestionHelper
  def match_question!
    @question.type = 'match'

    match1 = Moodle2CC::Moodle::Question::Match.new
    match1.code = 123
    match1.question_text = 'Ruby on Rails is written in this language'
    match1.answer_text = 'Ruby'

    match2 = Moodle2CC::Moodle::Question::Match.new
    match2.code = 234
    match2.question_text = ''
    match2.answer_text = 'Python'

    match3 = Moodle2CC::Moodle::Question::Match.new
    match3.code = 345
    match3.question_text = 'Files with .coffee extension use which language?'
    match3.answer_text = 'CoffeeScript'

    @question.matches = [match1, match2, match3]
  end

  def multiple_choice_question!
    @question.type = 'multichoice'

    answer1 = Moodle2CC::Moodle::Question::Answer.new
    answer1.id = 123
    answer1.text = 'Ruby'
    answer1.fraction = 1
    answer1.feedback = 'Yippee!'

    answer2 = Moodle2CC::Moodle::Question::Answer.new
    answer2.id = 234
    answer2.text = 'CoffeeScript'
    answer2.fraction = 0.75
    answer2.feedback = 'Nope'

    answer3 = Moodle2CC::Moodle::Question::Answer.new
    answer3.id = 345
    answer3.text = 'Java'
    answer3.fraction = 0.25
    answer3.feedback = 'No way'

    answer4 = Moodle2CC::Moodle::Question::Answer.new
    answer4.id = 456
    answer4.text = 'Clojure'
    answer4.fraction = 0
    answer4.feedback = 'Not even close'

    @question.answers = [answer1, answer2, answer3, answer4]
  end

  def multiple_dropdowns_question!
    @question.type = nil
    @question.type_id = 8 # rate 1..5 question
    @question.length = 3
    @question.text = nil
    @question.content = "This is a rating question"
    choice1 = Moodle2CC::Moodle::Question::Choice.new
    choice1.id = 1
    choice1.content = '1=Almost Never'
    choice2 = Moodle2CC::Moodle::Question::Choice.new
    choice2.id = 2
    choice2.content = '2=Sometimes'
    choice3 = Moodle2CC::Moodle::Question::Choice.new
    choice3.id = 3
    choice3.content = '3=Always'
    choice4 = Moodle2CC::Moodle::Question::Choice.new
    choice4.id = 4
    choice4.content = 'I test my code'
    choice5 = Moodle2CC::Moodle::Question::Choice.new
    choice5.id = 5
    choice5.content = 'I am happy'
    @question.choices = [choice1, choice2, choice3, choice4, choice5]
  end

  def multiple_dropdowns_question_without_choices!
    @question.type = nil
    @question.type_id = 8 # rate 1..5 question
    @question.length = 3
    @question.text = nil
    @question.content = "This is a rating question but not formatted very well"
    choice1 = Moodle2CC::Moodle::Question::Choice.new
    choice1.id = 1
    choice1.content = "this isn't actually a choice"
    choice2 = Moodle2CC::Moodle::Question::Choice.new
    choice2.id = 2
    choice2.content = 'so add the choices automatically'
    @question.choices = [choice1, choice2]
  end

  def multiple_answers_question!
    @question.type = nil
    @question.type_id = 5 # check boxes question
    @question.length = 3
    @question.text = nil
    @question.content = "What are your favorite languages?"
    choice1 = Moodle2CC::Moodle::Question::Choice.new
    choice1.id = 1
    choice1.content = 'Ruby'
    choice2 = Moodle2CC::Moodle::Question::Choice.new
    choice2.id = 2
    choice2.content = 'Javascript'
    choice3 = Moodle2CC::Moodle::Question::Choice.new
    choice3.id = 3
    choice3.content = 'Python'
    choice4 = Moodle2CC::Moodle::Question::Choice.new
    @question.choices = [choice1, choice2, choice3]
  end

  def numerical_question!
    @question = @mod.questions.find { |q| q.type == 'numerical' }
  end

  def short_answer_question!
    @question = @mod.questions.find { |q| q.type == 'shortanswer' }
  end

  def true_false_question!
    @question = @mod.questions.find { |q| q.type == 'truefalse' }
  end
end
