require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::PageParser do
  subject(:parser) {Moodle2CC::Moodle2::Parsers::PageParser.new(fixture_path(File.join('moodle2', 'backup')))}

  it 'parses a moodle2 page' do
    pages = parser.parse
    expect(pages.count).to eq 2
    page = pages.first
    expect(page.module_id).to eq '2'
    expect(page.id).to eq '1'
    expect(page.name).to eq 'My Sample Page'
    expect(page.intro).to eq "<p>Some Html Content\u00A0<strong>Bolded</strong> in the description</p>"
    expect(page.intro_format).to eq '1'
    expect(page.content).to include "<p>This is the page content, with a link to\u00A0<img src=\"@@PLUGINFILE@@/smaple_gif.gif\" width=\"400\" height=\"210\" alt=\"Image Description\" /></p>"
    expect(page.content_format).to eq '1'
    expect(page.legacy_files).to eq '0'
    expect(page.legacy_files_last).to eq nil
    expect(page.display).to eq '0'
    expect(page.display_options).to eq 'a:2:{s:12:"printheading";s:1:"0";s:10:"printintro";s:1:"0";}'
    expect(page.revision).to eq '3'
    expect(page.visible).to eq true
  end

end