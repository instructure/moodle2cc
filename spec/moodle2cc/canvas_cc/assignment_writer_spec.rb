require 'spec_helper'

describe Moodle2CC::CanvasCC::AssignmentWriter do
  subject { Moodle2CC::CanvasCC::AssignmentWriter.new(work_dir, assignment) }
  let(:work_dir) { Dir.mktmpdir }
  let(:assignment) { Moodle2CC::CanvasCC::Models::Assignment.new }

  after(:each) do
    FileUtils.rm_r work_dir
  end

  it 'creates the assignment settings xml' do
    assignment.identifier = 'assignment_id'
    assignment.title = 'Assignment Title'
    assignment.due_at = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
    assignment.lock_at = Time.parse('Sat, 08 Feb 2014 17:00:00 GMT')
    assignment.unlock_at = Time.parse('Sat, 08 Feb 2014 18:00:00 GMT')
    assignment.peer_reviews_due_at = Time.parse('Sat, 08 Feb 2014 19:00:00 GMT')
    assignment.all_day_date = Time.parse('Sat, 08 Feb 2014 00:00:00 GMT')
    assignment.assignment_group_identifier_ref = 'assignment_group_id'
    assignment.workflow_state = 'active'
    assignment.points_possible = '30'
    assignment.grading_type = 'points'
    assignment.all_day = 'true'
    assignment.submission_types = %w(online_text_entry online_url online_upload)
    assignment.position = '2'
    assignment.peer_review_count = '0'
    assignment.peer_reviews_assigned = 'false'
    assignment.peer_reviews = 'false'
    assignment.automatic_peer_reviews = 'true'
    assignment.grade_group_students_individually = 'false'
    assignment.muted = true

    subject.write
    xml = Nokogiri::XML(File.read(File.join(work_dir, assignment.assignment_resource.files.select{ |f| f.split(//).last(4).join("").to_s == '.xml'}.first)))
    expect(xml.at_xpath('xmlns:assignment/@identifier').value).to eq('assignment_id')
    expect(xml.%('assignment/title').text).to eq 'Assignment Title'
    expect(xml.%('assignment/due_at').text).to eq '2014-02-08T16:00:00'
    expect(xml.%('assignment/lock_at').text).to eq '2014-02-08T17:00:00'
    expect(xml.%('assignment/unlock_at').text).to eq '2014-02-08T18:00:00'
    expect(xml.%('assignment/all_day_date').text).to eq '2014-02-08T00:00:00'
    expect(xml.%('assignment/peer_reviews_due_at').text).to eq '2014-02-08T19:00:00'
    expect(xml.%('assignment/assignment_group_identifierref').text).to eq 'assignment_group_id'
    expect(xml.%('assignment/workflow_state').text).to eq 'active'
    expect(xml.%('assignment/points_possible').text).to eq '30'
    expect(xml.%('assignment/grading_type').text).to eq 'points'
    expect(xml.%('assignment/all_day').text).to eq 'true'
    expect(xml.%('assignment/submission_types').text).to eq 'online_text_entry,online_url,online_upload'
    expect(xml.%('assignment/position').text).to eq '2'
    expect(xml.%('assignment/peer_review_count').text).to eq '0'
    expect(xml.%('assignment/peer_reviews_assigned').text).to eq 'false'
    expect(xml.%('assignment/peer_reviews').text).to eq 'false'
    expect(xml.%('assignment/automatic_peer_reviews').text).to eq 'true'
    expect(xml.%('assignment/grade_group_students_individually').text).to eq 'false'
    expect(xml.%('assignment/muted').text).to eq 'true'

  end

  it 'creates the assignment html' do
    assignment.identifier = 'assignment_id'
    assignment.title = 'Assignment Title'
    assignment.body = '<p>My Body Content</p>'

    subject.write
    html = Nokogiri::HTML(File.read(File.join(work_dir, assignment.assignment_resource.href)))

    expect(html.at_css('meta[http-equiv]')[:'http-equiv']).to eq 'Content-Type'
    expect(html.at_css('meta[http-equiv]')[:content]).to eq 'text/html; charset=utf-8'
    expect(html.at_css('title').text).to eq 'Assignment: Assignment Title'
    expect(html.at_css('body').inner_html.to_s).to eq '<p>My Body Content</p>'

  end

end