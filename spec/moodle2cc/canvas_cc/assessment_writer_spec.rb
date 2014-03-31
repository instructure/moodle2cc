require 'spec_helper'

module Moodle2CC::CanvasCC
  describe AssessmentWriter do
    subject { Moodle2CC::CanvasCC::AssessmentWriter.new(work_dir, assessment) }
    let(:work_dir) { Dir.mktmpdir }
    let(:assessment) { Moodle2CC::CanvasCC::Models::Assessment.new }

    after(:each) do
      FileUtils.rm_r work_dir
    end

    it 'raises an error unless question references are first resolved' do
      expect { subject.write }.to raise_exception
    end

    it 'creates the assessment meta file' do

      assessment.identifier = 'someidthing'
      assessment.title = 'assersemurnt'
      assessment.description = 'this is a bunch of description'
      assessment.lock_at = Time.parse('Sat, 08 Feb 2014 17:00:00 GMT')
      assessment.unlock_at = Time.parse('Sat, 08 Feb 2014 18:00:00 GMT')
      assessment.time_limit = '12'
      assessment.allowed_attempts = '13'
      assessment.scoring_policy = '14'
      assessment.access_code = 'tired of counting'
      assessment.ip_filter = '42.42.42.42'
      assessment.shuffle_answers = "every day i'm shuffling answers"
      assessment.quiz_type = 'the best kind of quiz'

      assessment.items = []
      subject.write

      xml = Nokogiri::XML(File.read(File.join(work_dir, assessment.meta_file_path)))

      expect(xml.root.attributes['schemaLocation'].value).to eq "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd"
      expect(xml.namespaces['xmlns:xsi']).to eq "http://www.w3.org/2001/XMLSchema-instance"
      expect(xml.namespaces['xmlns']).to eq "http://canvas.instructure.com/xsd/cccv1p0"

      root = xml.at_xpath('xmlns:quiz')
      expect(root.attributes['identifier'].value).to eq assessment.identifier
      expect(root.%('title').text).to eq assessment.title
      expect(root.%('description').text).to eq assessment.description
      expect(root.%('lock_at').text).to eq '2014-02-08T17:00:00'
      expect(root.%('unlock_at').text).to eq '2014-02-08T18:00:00'
      expect(root.%('time_limit').text).to eq assessment.time_limit
      expect(root.%('allowed_attempts').text).to eq assessment.allowed_attempts
      expect(root.%('scoring_policy').text).to eq assessment.scoring_policy
      expect(root.%('access_code').text).to eq assessment.access_code
      expect(root.%('ip_filter').text).to eq assessment.ip_filter
      expect(root.%('shuffle_answers').text).to eq assessment.shuffle_answers
      expect(root.%('quiz_type').text).to eq assessment.quiz_type
    end

    it 'creates the assessment qti file' do
      assessment.identifier = 'someidthing'
      assessment.title = 'assersemurnt'
      assessment.time_limit = 10
      assessment.allowed_attempts = 2

      question = Moodle2CC::CanvasCC::Models::Question.new
      question.identifier = 42
      assessment.items = [question]

      QuestionWriter.register_writer_type(nil)
      QuestionWriter.stub(:write_responses)
      QuestionWriter.stub(:write_response_conditions)

      subject.write

      xml = Nokogiri::XML(File.read(File.join(work_dir, assessment.qti_file_path)))

      expect(xml.root.attributes['schemaLocation'].value).to eq "http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd"
      expect(xml.namespaces['xmlns:xsi']).to eq "http://www.w3.org/2001/XMLSchema-instance"
      expect(xml.namespaces['xmlns']).to eq "http://www.imsglobal.org/xsd/ims_qtiasiv1p2"

      root = xml.at_xpath('xmlns:questestinterop')
      expect(root).to_not be_nil
      expect(root.%('assessment').attributes['ident'].value).to eq assessment.identifier
      expect(root.%('assessment').attributes['title'].value).to eq assessment.title

      meta_fields = root.search('assessment/qtimetadata/qtimetadatafield')
      expect(meta_fields[0].%('fieldlabel').text).to eq 'qmd_timelimit'
      expect(meta_fields[0].%('fieldentry').text).to eq assessment.time_limit.to_s
      expect(meta_fields[1].%('fieldlabel').text).to eq 'cc_maxattempts'
      expect(meta_fields[1].%('fieldentry').text).to eq assessment.allowed_attempts.to_s

      section = root.%('assessment/section')
      expect(section.attributes['ident'].value).to eq 'root_section'
      expect(section.%('item').attributes['ident'].value).to eq question.identifier.to_s
    end

  end
end