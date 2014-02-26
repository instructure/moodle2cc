require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  module Model
    class Moodle2FileTest < MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @file = Moodle2CC::Moodle2::Model::Moodle2File.new
      end

      def teardown
        # Do nothing
      end

      def test_accessors
        assert_accessors( @file, :id, :content_hash, :context_id, :component, :file_area, :item_id, :file_path,
                          :file_name, :user_id, :mime_type, :status, :time_created, :time_modified, :source,
                          :author, :license, :sort_order, :repository_type, :repository_id, :reference, :file_location )
        @file.file_size = '0'
        @file.file_size.must_equal 0
      end

    end
  end
end
