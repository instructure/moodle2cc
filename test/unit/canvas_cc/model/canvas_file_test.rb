require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  module Model
    class CanvasFileTest< MiniTest::Unit::TestCase
      include TestHelper

      def setup
        @file = Moodle2CC::CanvasCC::Model::CanvasFile.new
      end

      def teardown
        # Do nothing
      end


      def test_file
        assert_accessors(@file, :file_location)
        @file.identifier = 'foo_bar'
        @file.file_path = 'myfile.txt'
        @file.must_be_kind_of Moodle2CC::CanvasCC::Model::Resource
        @file.identifier.must_equal 'CC_5c7d96a3dd7a87850a2ef34087565a6e_FILE'
        @file.file_path.must_equal 'myfile.txt'
        @file.files.count.must_equal 1
        @file.files.first.must_equal 'web_resources/myfile.txt'
        @file.href.must_equal 'web_resources/myfile.txt'
        @file.attributes[:identifier].must_equal 'CC_5c7d96a3dd7a87850a2ef34087565a6e_FILE'
        @file.attributes[:type].must_equal 'webcontent'

      end

    end
  end
end
