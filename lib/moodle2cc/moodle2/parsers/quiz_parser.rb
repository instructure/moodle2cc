module Moodle2CC::Moodle2::Parsers
  class QuizParser
    include ParserHelper

    QUIZ_XML = 'quiz.xml'
    QUIZ_MODULE_NAME = 'quiz'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, QUIZ_MODULE_NAME)
      activity_dirs.map { |dir| parse_quiz(dir) }
    end

    private

    def parse_quiz(dir)
      quiz = Moodle2CC::Moodle2::Models::Quizzes::Quiz.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, QUIZ_XML)) do |f|
        xml = Nokogiri::XML(f)
        quiz.id = xml.at_xpath('/activity/quiz/@id').value
        quiz.module_id = xml.at_xpath('/activity/@moduleid').value
        quiz.name = parse_text(xml, '/activity/quiz/name')
        quiz.intro = parse_text(xml, '/activity/quiz/intro')
        quiz.intro_format = parse_text(xml, '/activity/quiz/introformat')
        quiz.time_open = parse_text(xml, '/activity/quiz/timeopen')
        quiz.time_close = parse_text(xml, '/activity/quiz/timeclose')
        quiz.time_limit = parse_text(xml, '/activity/quiz/timelimit')
        quiz.overdue_handling = parse_text(xml, '/activity/quiz/overduehandling')
        quiz.grace_period = parse_text(xml, '/activity/quiz/graceperiod')
        quiz.preferred_behavior = parse_text(xml, '/activity/quiz/preferredbehaviour')
        quiz.attempts_number = parse_text(xml, '/activity/quiz/attempts_number')
        quiz.attempt_on_last = parse_text(xml, '/activity/quiz/attemptonlast')
        quiz.grade_method = parse_text(xml, '/activity/quiz/grademethod')
        quiz.decimal_points = parse_text(xml, '/activity/quiz/decimalpoints')
        quiz.question_decimal_points = parse_text(xml, '/activity/quiz/questiondecimalpoints')
        quiz.review_attempt = parse_text(xml, '/activity/quiz/reviewattempt')
        quiz.review_correctness = parse_text(xml, '/activity/quiz/reviewcorrectness')
        quiz.review_marks = parse_text(xml, '/activity/quiz/reviewmarks')
        quiz.review_specific_feedback = parse_text(xml, '/activity/quiz/reviewspecificfeedback')
        quiz.review_general_feedback = parse_text(xml, '/activity/quiz/reviewgeneralfeedback')
        quiz.review_right_answer = parse_text(xml, '/activity/quiz/reviewrightanswer')
        quiz.review_overall_feedback = parse_text(xml, '/activity/quiz/reviewoverallfeedback')
        quiz.questions_per_page = parse_text(xml, '/activity/quiz/questionsperpage')
        quiz.nav_method = parse_text(xml, '/activity/quiz/navmethod')

        quiz.shuffle_questions = parse_boolean(xml, '/activity/quiz/shufflequestions')
        quiz.shuffle_answers = parse_boolean(xml, '/activity/quiz/shuffleanswers')

        quiz.sum_grades = parse_text(xml, '/activity/quiz/sumgrades')
        quiz.grade = parse_text(xml, '/activity/quiz/grade')
        quiz.time_created = parse_text(xml, '/activity/quiz/timecreated')
        quiz.time_modified = parse_text(xml, '/activity/quiz/timemodified')
        quiz.password = parse_text(xml, '/activity/quiz/password')
        quiz.subnet = parse_text(xml, '/activity/quiz/subnet')
        quiz.browser_security = parse_text(xml, '/activity/quiz/browsersecurity')
        quiz.delay1 = parse_text(xml, '/activity/quiz/delay1')
        quiz.delay2 = parse_text(xml, '/activity/quiz/delay2')
        quiz.show_user_picture = parse_text(xml, '/activity/quiz/showuserpicture')
        quiz.show_blocks = parse_text(xml, '/activity/quiz/showblocks')

        xml.search('/activity/quiz/question_instances/question_instance').each do |node|
          quiz.question_instances << {
            :question => parse_text(node, 'question') || parse_text(node, 'questionid'),
            :bank_entry_id => parse_text(node, 'question_reference/questionbankentryid'),
            :grade => parse_text(node, 'grade') || parse_text(node, 'maxmark')
          }
        end

        question_order = parse_text(xml, '/activity/quiz/questions').to_s.split(',')
        unless question_order.empty?
          quiz.question_instances.sort_by!{|qi| question_order.index(qi[:question]) || 0}
        end

        xml.search('/activity/quiz/feedbacks/feedback').each do |node|
          quiz.feedbacks << {
            :text => parse_text(node, 'feedbacktext'),
            :format => parse_text(node, 'feedbacktextformat'),
            :min_grade => parse_text(node, 'mingrade'),
            :max_grade => parse_text(node, 'maxgrade')
          }
        end
      end
      parse_module(activity_dir, quiz)

      quiz
    end

  end
end
