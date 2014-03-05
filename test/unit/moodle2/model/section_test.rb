require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  module Model
    class SectionTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @section = Moodle2CC::Moodle2::Models::Section.new
      end

      def teardown
        # Do nothing
      end

      # Fake test
      def test_accessors
        assert_accessors(@section, :id, :number, :name, :summary, :summary_format, :sequence, :visible, :available_from,
                         :available_until, :release_code, :show_availability, :grouping_id, :position)
      end
    end
  end
end