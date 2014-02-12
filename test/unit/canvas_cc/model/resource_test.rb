require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model
    class ResourceTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        # Do nothing
      end

      def teardown
        # Do nothing
      end


      def test_resource
        resource = Moodle2CC::CanvasCC::Model::Resource.new
        assert_accessors(resource, :identifier, :type, :href)
        assert_equal(resource.files.class, Array)
        assert_equal(resource.attributes.class, Hash)
      end

    end
  end
end
