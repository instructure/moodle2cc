require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe ExternalUrlParser do

    subject { ExternalUrlParser.new(fixture_path(File.join('moodle2', 'backup'))) }

    it 'parses external urls' do
      external_urls = subject.parse
      expect(external_urls.count).to eq(1)

      external_url = external_urls.first
      expect(external_url.module_id).to eq('15')
      expect(external_url.id).to eq('1')
      expect(external_url.name).to eq('my sample url')
      expect(external_url.intro).to eq('<p>Sample url description</p>')
      expect(external_url.intro_format).to eq('1')
      expect(external_url.external_url).to eq('http://www.youtube.com/v/F7qKiVjCfuM#Monkey Island 2 Special Edition Funny Moments')
      expect(external_url.display).to eq('0')
      expect(external_url.display_options).to eq('a:2:{s:12:"printheading";i:0;s:10:"printintro";i:1;}')
      expect(external_url.parameters).to eq('a:0:{}')
      expect(external_url.visible).to eq true
    end

  end
end