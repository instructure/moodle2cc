require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CavnasCC
  module Model
    class CanvasModuleTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @module = Moodle2CC::CanvasCC::Model::CanvasModule.new
      end

      def teardown
        # Do nothing
      end


      def test_accessors
        assert_accessors(@module, :title, :workflow_state, :position)
      end

      def test_identifier
        @module.identifier = '4321_ident'
        assert_equal("module_#{Digest::MD5.hexdigest("4321_ident")}", @module.identifier)
      end

    end
  end
end