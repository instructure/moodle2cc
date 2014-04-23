require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::WikiParser do
  subject(:parser) {Moodle2CC::Moodle2::Parsers::WikiParser.new(fixture_path(File.join('moodle2', 'backup')))}

  it 'parses a moodle2 wiki' do
    wikis = parser.parse
    expect(wikis.count).to eq 1
    wiki = wikis.first

    expect(wiki.module_id).to eq '58541'
    expect(wiki.id).to eq '19'
    expect(wiki.name).to eq 'wiki name'
    expect(wiki.intro).to eq "<p>wiki page description.</p>"
    expect(wiki.intro_format).to eq '1'
    expect(wiki.visible).to eq true
    expect(wiki.first_page_title).to eq 'Main Page'
    pages = [{:id => '27', :title => "Main Page", :content => "<p>front page content</p>"},
             {:id => '28', :title => "other page", :content => "<p>other page content</p>"}]
    expect(wiki.pages).to eq pages
  end

end