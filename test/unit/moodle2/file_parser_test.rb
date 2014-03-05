require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  class FileParserTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @file_parser = Moodle2CC::Moodle2::FileParser.new(fixture_path(File.join('moodle2', 'backup')))
    end

    def teardown
      # Do nothing
    end


    def test_files_parsing
      files = @file_parser.parse
      assert_equal(3, files.count)
      file = files.find{|f| f.id == '29'}
      assert_equal(file.id, '29')
      assert_equal(file.content_hash, 'a0f324310c8d8dd9c79458986c4322f5a060a1d9')
      assert_equal(file.context_id, '26')
      assert_equal(file.component, 'mod_folder')
      assert_equal(file.file_area, 'content')
      assert_equal(file.item_id, '0')
      assert_equal(file.file_path, '/')
      assert_equal(file.file_name, 'smaple_gif.gif')
      assert_equal(file.user_id, '2')
      assert_equal(file.file_size, 2444236)
      assert_equal(file.mime_type, 'image/gif')
      assert_equal(file.status, '0')
      assert_equal(file.time_created, '1394041688')
      assert_equal(file.time_modified, '1394041712')
      assert_equal(file.source, 'Server files: Miscellaneous/Sample Course/Test File (File)/Files and subfolders/smaple_gif.gif')
      assert_equal(file.author, 'Admin User')
      assert_equal(file.license, 'allrightsreserved')
      assert_equal(file.sort_order, '0')
      assert_equal(file.repository_type, nil)
      assert_equal(file.repository_id, nil)
      assert_equal(file.reference, nil)
    end

  end
end