module Moodle2CC::CanvasCC
  class QuestionBankWriter

    def initialize(work_dir, *question_banks)
      @work_dir = work_dir
      @question_banks = question_banks
    end

    def write
      @question_banks.each do |bank|
        write_bank(bank)
      end
    end

    private

    def write_bank(bank)
      # TODO
    end

  end
end