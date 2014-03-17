require 'spec_helper'

describe Moodle2CC::CanvasCC::PageWriter do
  subject(:writer) { Moodle2CC::CanvasCC::PageWriter.new(work_dir, page) }
  let(:work_dir) { Dir.mktmpdir }
  let(:page) {Moodle2CC::CanvasCC::Model::Page.new}

  after(:each) do
    FileUtils.rm_r work_dir
  end

  it 'creates the page html' do
    page.identifier = 'my_id'
    page.workflow_state = 'active'
    page.body = '<h2>This is the body</h2>'
    page.editing_roles = 'teachers'
    page.page_name ='My Page Title'
    writer.write
    html = Nokogiri::HTML(File.read(File.join(work_dir, page.href)))
    expect(html.at_css('meta[http-equiv]')[:'http-equiv']).to eq 'Content-Type'
    expect(html.at_css('meta[http-equiv]')[:content]).to eq 'text/html; charset=utf-8'
    expect(html.at_css('meta[name=identifier]')[:content]).to eq 'my_id'
    expect(html.at_css('meta[name=editing_roles]')[:content]).to eq 'teachers'
    expect(html.at_css('meta[name=workflow_state]')[:content]).to eq 'active'
    expect(html.at_css('title').text).to eq 'My Page Title'
    expect(html.at_css('body').inner_html.to_s).to eq '<h2>This is the body</h2>'
  end

end