require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model

    class WebContentTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @web_content = Moodle2CC::CanvasCC::Model::WebContent.new
      end

      def test_accessors
        assert_accessors(@web_content, :body)
      end

    end
  end
end
