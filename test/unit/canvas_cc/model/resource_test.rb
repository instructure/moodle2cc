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
        resource.identifier = 'test_id'
        assert_accessors(resource, :type, :href)
        assert_equal(resource.files.class, Array)
        assert_equal({identifier: 'CC_2e06cda4c3c0d4a2a42058f74641546a'}, resource.attributes)
        assert_equal('CC_2e06cda4c3c0d4a2a42058f74641546a' ,resource.identifier )
      end

    end
  end
end
