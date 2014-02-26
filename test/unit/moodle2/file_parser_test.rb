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
      files.count.must_equal(1)
      file = files[0]
      file.id.must_equal('7')
      file.content_hash.must_equal('a0f324310c8d8dd9c79458986c4322f5a060a1d9')
      file.context_id.must_equal('21')
      file.component.must_equal('mod_page')
      file.file_area.must_equal('content')
      file.item_id.must_equal('0')
      file.file_path.must_equal('/')
      file.file_name.must_equal('smaple_gif.gif')
      file.user_id.must_equal('2')
      file.file_size.must_equal(2444236)
      file.mime_type.must_equal('image/gif')
      file.status.must_equal('0')
      file.time_created.must_equal('1392877532')
      file.time_modified.must_equal('1392877562')
      file.source.must_equal('1.gif')
      file.author.must_equal('Admin User')
      file.license.must_equal('allrightsreserved')
      file.sort_order.must_equal('0')
      file.repository_type.must_equal(nil)
      file.repository_id.must_equal(nil)
      file.reference.must_equal(nil)
      file.file_location.must_include('files/a0/a0f324310c8d8dd9c79458986c4322f5a060a1d9')
    end

  end
end