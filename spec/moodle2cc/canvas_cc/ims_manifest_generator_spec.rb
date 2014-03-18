require 'spec_helper'

module Moodle2CC::CanvasCC
  describe ImsManifestGenerator do

    let(:course) { Models::Course.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      course.identifier = 'manifest_identifier'
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'xml contains the correct schema' do
      course.title = 'Course Title'
      course.copyright = 'copyright text'
      xml = write_xml(course)
      assert_xml_schema(xml)
    end

    describe 'metadata' do
      it 'has valid metadata' do
        course.title = 'Course Title'
        xml = write_xml(course)

        expect(xml.at_xpath('/xmlns:manifest/xmlns:metadata/xmlns:schema').text).to eq('IMS Common Cartridge')
        expect(xml.at_xpath('/xmlns:manifest/xmlns:metadata/xmlns:schemaversion').text).to eq('1.1.0')

        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        expect(lom.at_xpath('lomimscc:general/lomimscc:title/lomimscc:string').text).to eq(course.title)
      end

      it 'has copyright' do
        course.copyright = 'copyright text'
        xml = write_xml(course)

        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        expect(lom.at_xpath('lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text).to eq('yes')
        expect(lom.at_xpath('lomimscc:rights/lomimscc:description/lomimscc:string').text).to eq(course.copyright)
      end

      it 'has no copyright' do
        xml = write_xml(course)

        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        expect(lom.at_xpath('lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text).to eq('no')
        expect(lom.at_xpath('lomimscc:rights/lomimscc:description/lomimscc:string')).to be_nil
      end
    end

    describe 'resources' do
      it 'has valid resource settings' do
        course.canvas_modules << Models::CanvasModule.new
        xml = write_xml(course)

        resources_node = xml.%('manifest/resources')
        expect(resources_node.at_xpath('xmlns:resource/@href').value).to eq('course_settings/canvas_export.txt')
        expect(resources_node.at_xpath('xmlns:resource/@type').value).to eq('associatedcontent/imscc_xmlv1p1/learning-application-resource')
        expect(resources_node.at_xpath('xmlns:resource/@identifier').value).to eq('CC_a3fb2739667c53b95ec26fe321a70f59_settings')

        files = resources_node.xpath('xmlns:resource/xmlns:file/@href').map(&:value)
        expect(files).to include('course_settings/course_settings.xml')
        expect(files).to include('course_settings/module_meta.xml')
      end

      it 'has valid resource' do
        resource = Models::Resource.new
        resource.identifier = 'resource_identifier'
        resource.type = 'resource_type'
        resource.href = 'resource_href'
        resource.files << 'file_1'
        resource.files << 'file_2'
        resource.dependencies << :dependency
        course.resources << resource
        xml = write_xml(course)

        base_node = xml.at_xpath("/xmlns:manifest/xmlns:resources/xmlns:resource[@identifier='CC_bfb11a99f5f71d2e1f51844f43402df3']")
        expect(base_node.at_xpath('@type').value).to eq('resource_type')
        expect(base_node.at_xpath('@href').value).to eq('resource_href')
        expect(base_node.xpath("xmlns:file[@href='file_1']").count).to eq(1)
        expect(base_node.xpath("xmlns:file[@href='file_2']").count).to eq(1)
        expect(base_node.xpath("xmlns:dependency[@identifierref='dependency']").count).to eq(1)
      end
    end

    describe 'organizations' do
      it 'writes learning modules' do
        canvas_module = Models::CanvasModule.new
        canvas_module.title = 'my module title'
        canvas_module.identifier = 'my_id'
        course.canvas_modules << canvas_module
        xml = write_xml(course)

        org_node = xml.at_xpath('/xmlns:manifest/xmlns:organizations/xmlns:organization')
        expect(org_node.at_xpath('@structure').value).to eq('rooted-hierarchy')
        expect(org_node.at_xpath('@identifier').value).to eq('org_1')
        expect(org_node.at_xpath('xmlns:item/@identifier').value).to eq('LearningModules')
        expect(org_node.at_xpath('xmlns:item/xmlns:item/@identifier').value).to eq('module_011ed73876357cbeeb11abdc2b7e1c0b')
        expect(org_node.%('item/title').text).to eq('my module title')
      end

      it 'writes module items' do
        canvas_module = Models::CanvasModule.new

        module_item = Models::ModuleItem.new
        module_item.identifier = 'module_item_unique_identifier'
        module_item.title = 'Module Item'
        module_item.identifierref = 'resource_unique_identifier'

        canvas_module.module_items << module_item
        course.canvas_modules << canvas_module

        xml = write_xml(course)
        module_node = xml.at_xpath('/xmlns:manifest').%('organizations/organization/item/item')
        expect(module_node.at_xpath('xmlns:item/@identifier').value).to eq 'module_item_unique_identifier'
        expect(module_node.at_xpath('xmlns:item/@identifierref').value).to eq 'resource_unique_identifier'
        expect(module_node.%('item/title').text).to eq 'Module Item'
      end
    end

    private

    def write_xml(course)
      generator = ImsManifestGenerator.new(tmpdir, course)
      generator.write

      path = File.join(tmpdir, ImsManifestGenerator::MANIFEST_FILE_NAME)
      Nokogiri::XML(File.read(path))
    end

    def assert_xml_schema(xml)
      valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'ccv1p1_imscp_v1p2_v1p0.xsd')))
      xsd = Nokogiri::XML::Schema(valid_schema)
      expect(xsd.validate(xml)).to be_empty
    end

  end
end