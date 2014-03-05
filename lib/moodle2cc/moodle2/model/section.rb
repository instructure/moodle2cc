module Moodle2CC::Moodle2::Model
  class Section
    attr_accessor :id, :number, :name, :summary, :summary_format, :sequence, :visible, :available_from, :available_until,
                  :release_code, :show_availability, :grouping_id, :position
  end
end