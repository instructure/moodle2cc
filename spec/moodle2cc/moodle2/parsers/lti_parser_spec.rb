require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe LtiParser do

    subject { LtiParser.new(fixture_path(File.join('moodle2', 'backup'))) }

    it 'parses lti links and assignments' do
      lti_links = subject.parse
      expect(lti_links.count).to eq(2)

      lti_assign = lti_links.detect { |a| a.id == '47236' }
      expect(lti_assign).to be_a(Moodle2CC::Moodle2::Models::Assignment)
      expect(lti_assign.module_id).to eq('78841')
      expect(lti_assign.name).to eq('eTeacher Guide')
      expect(lti_assign.external_tool_url).to eq('https://lti.flvsgl.com/tool.php?id=11&launch=educator_psychology1_v14_gs_guide/index.htm')
      expect(lti_assign.visible).to eq false
      expect(lti_assign.intro).to eq 'blah'
      expect(lti_assign.grade).to eq '100'

      lti_link = lti_links.detect { |a| a.id == '306565' }
      expect(lti_link).to be_a(Moodle2CC::Moodle2::Models::Lti)
      expect(lti_link.module_id).to eq('421027')
      expect(lti_link.name).to eq('Plate Tectonics 1')
      expect(lti_link.url).to eq('https://www.thelearningodyssey.com/lti/resources/learningactivity/ea003')
      expect(lti_link.visible).to eq true
    end
  end
end