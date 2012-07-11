module Moodle2CC::CC
  class Assessment
    include CCHelper
    include Resource

    META_ATTRIBUTES = [:title, :description, :lock_at, :unlock_at, :allowed_attempts,
      :scoring_policy, :access_code, :ip_filter, :shuffle_answers, :time_limit]

    attr_accessor *META_ATTRIBUTES

    def initialize(mod, position=0)
      super
      @description = convert_file_path_tokens(mod.intro)
      if mod.time_close.to_i > 0
        @lock_at = ims_datetime(Time.at(mod.time_close))
      end
      if mod.time_open.to_i > 0
        @unlock_at = ims_datetime(Time.at(mod.time_open))
      end
      @time_limit = mod.time_limit
      @allowed_attempts = mod.attempts_number
      @scoring_policy = mod.grade_method == 4 ? 'keep_latest' : 'keep_highest'
      @access_code = mod.password
      @ip_filter = mod.subnet
      @shuffle_answers = mod.shuffle_answers
    end
  end
end
