require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  module Model
    class SectionTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @section = Moodle2CC::Moodle2::Model::Section.new
      end

      def teardown
        # Do nothing
      end

      # Fake test
      def test_accessors
        assert_accessors(@section, :id, :number, :name, :summary, :summaryformat, :sequence, :visible, :availableuntil,
                         :releasecode, :show_availability, :groupingid)
      end
    end
  end
end