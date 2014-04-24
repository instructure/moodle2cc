require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::HtmlConverter do
    subject { Moodle2Converter::HtmlConverter.new(canvas_course.files, moodle_course) }
    let(:canvas_course) do
      course = CanvasCC::Models::Course.new
      course.files = ('a'..'c').map do |id|
        file = CanvasCC::Models::CanvasFile.new
        file.identifier = id
        file.file_path = '/path/'+ id
        file
      end
      course
    end

    let(:moodle_course) do
      course = Moodle2::Models::Course.new
      ('a'..'c').map do |hash|
        file = Moodle2::Models::Moodle2File.new
        file.id = hash.ord
        file.content_hash = hash
        file.file_name = "#{hash}#{hash.ord}"
        file.file_path = '/'
        course.files << file
      end
      course
    end

    it 'removes id="main" attributes' do
      html = '<div id="main">Some Content</div>'
      expect(subject.convert(html)).to_not include('id="main"')
    end

    it 'replaces moodle2 img src with canvas url' do
      content = '<p>a link to <img src="@@PLUGINFILE@@/a97" alt="Image Description" ></p>'
      html = Nokogiri::HTML.fragment(subject.convert(content))
      expect(html.css('img').first.attr('src')).to eq '%24IMS_CC_FILEBASE%24/path/a'
    end

    it 'replaces moodle 2 url in hrefs with canvas url' do
      content = '<p>a link to <a href="@@PLUGINFILE@@/a97"></p>'
      html = Nokogiri::HTML.fragment(subject.convert(content))
      expect(html.css('a[href]').first.attr('href')).to eq '%24IMS_CC_FILEBASE%24/path/a'
    end

    it 'removes link tags' do
      content = '<p>a link to <link href="@@PLUGINFILE@@/a97"></p>'
      expect(subject.convert(content)).to eq ('<p>a link to </p>')
    end

    it "doesn't replace external links" do
      content = '<p>a link to <img src="www.example.com/sample.gif" alt="Image Description"></p>'
      expect(subject.convert(content)).to eq content
    end

    it 'replaces links with spaces in path' do
      file = CanvasCC::Models::CanvasFile.new
      file.identifier = 'content_hash'
      file.file_path = '/my_dir/'+ 'test.txt'
      file
      canvas_course.files << file

      file = Moodle2::Models::Moodle2File.new
      file.id = 'moodle_file_id'
      file.content_hash = 'content_hash'
      file.file_name = 'text.txt'
      file.file_path = '/path with space/'
      moodle_course.files << file

      content = '<p>a link to <a href="@@PLUGINFILE@@/path%20with%20space/text.txt"></p>'
      html = Nokogiri::HTML.fragment(subject.convert(content))
      expect(html.css('a[href]').first.attr('href')).to eq '%24IMS_CC_FILEBASE%24/my_dir/test.txt'
    end

    it 'replaces a moodle2 page url with a canvas url' do
      page = Moodle2::Models::Page.new
      page.id = '56439'
      page.name = 'my_page_name'
      moodle_course.pages << page
      content = '<p>a link to <a href="http://moodle.install.edu/mod/page/view.php?id=56439#Lesson3-1"></a></p>'

      html = Nokogiri::HTML.fragment(subject.convert(content))

      expect(html.css('a[href]').first.attr('href')).to eq '%24WIKI_REFERENCE%24/pages/my_page_name#Lesson3-1'
    end

    it 'replaces a moodle2 forum url with a canvas url' do
      forum = Moodle2::Models::Forum.new
      forum.id = '56439'
      forum.name = 'my_page_name'
      moodle_course.forums << forum
      content = '<p>a link to <a href="http://moodle.install.edu/mod/forum/view.php?id=56439#Lesson3-1"></a></p>'

      html = Nokogiri::HTML.fragment(subject.convert(content))

      expect(html.css('a[href]').first.attr('href')).to eq '%24CANVAS_OBJECT_REFERENCE%24/discussion_topics/m2c98831cde22c0529955a2218a2ed66bc_discussion#Lesson3-1'
    end

    it 'replaces a moodle2 assignment url with a canvas url' do
      assignment = Moodle2::Models::Assignment.new
      assignment.id = '56439'
      assignment.name = 'my_page_name'
      moodle_course.assignments << assignment
      content = '<p>a link to <a href="http://moodle.install.edu/mod/assignment/view.php?id=56439"></a></p>'

      html = Nokogiri::HTML.fragment(subject.convert(content))

      expect(html.css('a[href]').first.attr('href')).to eq '%24CANVAS_OBJECT_REFERENCE%24/assignments/m2c98831cde22c0529955a2218a2ed66bc_assignment'
    end

    it 'replaces @assignview links with canvas links' do
      assignment = Moodle2::Models::Assignment.new
      assignment.id = '56439'
      assignment.name = 'my_page_name'
      moodle_course.assignments << assignment
      content = '<p>a link to <a href="$@ASSIGNVIEWBYID*56439@$"></a></p>'

      html = Nokogiri::HTML.fragment(subject.convert(content))

      expect(html.css('a[href]').first.attr('href')).to eq '%24CANVAS_OBJECT_REFERENCE%24/assignments/m2c98831cde22c0529955a2218a2ed66bc_assignment'
    end

    it 'returns the original url if a matching moodle activity is not found' do
      content = '<p>a link to <a href="http://moodle.install.edu/mod/assignment/view.php?id=56439"></a></p>'

      html = Nokogiri::HTML.fragment(subject.convert(content))

      expect(html.css('a[href]').first.attr('href')).to eq 'http://moodle.install.edu/mod/assignment/view.php?id=56439'
    end

    it 'replaces moodle file urls' do
      file = CanvasCC::Models::CanvasFile.new
      file.identifier = 'content_hash'
      file.file_path = '/graphics/'+ 'arrow.JPG'
      file
      canvas_course.files << file

      file = Moodle2::Models::Moodle2File.new
      file.id = 'moodle_file_id'
      file.content_hash = 'content_hash'
      file.file_name = 'arrow.JPG'
      file.file_path = '/graphics/'
      moodle_course.files << file

      content = '<p> a link to <a href="http://moodle.extn.washington.edu/file.php/908/graphics/arrow.JPG">link</a></p>'
      html = Nokogiri::HTML.fragment(subject.convert(content))
      expect(html.css('a[href]').first.attr('href')).to eq '%24IMS_CC_FILEBASE%24/graphics/arrow.JPG'

    end

    context 'audio link conversion' do
      it 'converts mp3 links to html5 audio tags' do
        content = '<a href="/some/path/to/music.mp3">My Music</a>'
        html = subject.convert(content)

        expect(html).to eq '<audio controls="controls"><source src="/some/path/to/music.mp3" type="audio/mp3"></source><a href="/some/path/to/music.mp3">My Music</a></audio>'
      end

      it 'converts wav links to html5 audio tags' do
        content = '<a href="/some/path/to/music.wav">My Music</a>'
        html = subject.convert(content)

        expect(html).to eq '<audio controls="controls"><source src="/some/path/to/music.wav" type="audio/wav"></source><a href="/some/path/to/music.wav">My Music</a></audio>'
      end
    end

    context 'video link conversion' do
      it 'converts mp4 links to html5 video tags' do
        content = '<a href="/some/path/to/video.mp4">My Video</a>'
        html = subject.convert(content)

        expect(html).to eq '<audio controls="controls"><source src="/some/path/to/video.mp4" type="video/mp4"></source><a href="/some/path/to/video.mp4">My Video</a></audio>'
      end

      it 'converts webm links to html5 video tags' do
        content = '<a href="/some/path/to/video.webm">My Video</a>'
        html = subject.convert(content)

        expect(html).to eq '<audio controls="controls"><source src="/some/path/to/video.webm" type="video/webm"></source><a href="/some/path/to/video.webm">My Video</a></audio>'
      end
    end

    it 'converts equations into canvas equations' do
      content = 'stuff $$a + b$$'
      html = subject.convert(content)
      expect(html).to eq "stuff <img class=\"equation_image\" title=\"a + b\" alt=\"a + b\" src=\"/equation_images/a%2520%252B%2520b\">"
    end

  end
end