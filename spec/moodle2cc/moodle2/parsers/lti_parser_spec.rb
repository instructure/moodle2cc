require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe LtiParser do

    subject { LtiParser.new(fixture_path(File.join('moodle2', 'backup'))) }

    it 'parses lti links' do
      lti_links = subject.parse
      expect(lti_links.count).to eq(1)

      lti_link = lti_links.first
      expect(lti_link.module_id).to eq('78841')
      expect(lti_link.id).to eq('47236')
      expect(lti_link.name).to eq('eTeacher Guide')
      expect(lti_link.url).to eq('https://lti.flvsgl.com/tool.php?id=11&launch=educator_psychology1_v14_gs_guide/index.htm')
      expect(lti_link.visible).to eq false
    end

  end
end