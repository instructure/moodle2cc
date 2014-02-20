class Moodle2CC::CanvasCC::ImsManifestGenerator

  MANIFEST_FILE_NAME = 'imsmanifest.xml'
  SCHEMA = 'IMS Common Cartridge'
  SCHEMA_VERSION = '1.1.0'
  LOMIMSCC = 'lomimscc'
  SETTINGS_POSTFIX = '_settings'
  TYPE_LAR = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
  CANVAS_EXPORT_PATH = 'course_settings/canvas_export.txt'

  def initialize(work_dir, course)
    @work_dir = work_dir
    @course = course
  end

  def write
    xml = Nokogiri::XML::Builder.new do |xml|
      manifest(xml) do |xml|
        metadata(xml)
        organizations(xml)
        resources(xml, @course.resources)
      end
    end.to_xml
    File.open(File.join(@work_dir, MANIFEST_FILE_NAME), 'w' ) {|f| f.write(xml)}
  end

  private

  def manifest(xml)
    xml.manifest(
      "identifier" => @course.identifier,
      "xmlns" => "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1",
      "xmlns:lom" => "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource",
      "xmlns:lomimscc" => "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest",
      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation" => "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imscp_v1p2_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lomresource_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lommanifest_v1p0.xsd"
    ) {
      yield xml
    }
  end

  def metadata(xml)
    xml.metadata {
      xml.schema SCHEMA
      xml.schemaversion SCHEMA_VERSION
      ns = LOMIMSCC
      xml[ns].lom {
        xml[ns].general {
          xml[ns].title {
            xml[ns].string @course.title
          }
        }
        rights(xml)
      }
    }
  end

  def rights(xml)
    ns = LOMIMSCC
    has_copyright = @course.copyright && !@course.copyright.empty?
    xml[ns].rights {
      xml[ns].copyrightAndOtherRestrictions {
        xml[ns].value has_copyright ? 'yes' : 'no'
      }
      if has_copyright
        xml[ns].description {
          xml[ns].string @course.copyright
        }
      end
    }
  end


  def organizations(xml)
    canvas_modules = @course.canvas_modules
    xml.organizations { |xml|
      if canvas_modules.count > 0
        xml.organization('identifier' => 'org_1', 'structure' => 'rooted-hierarchy') { |xml|
          canvas_modules.each do |mod|
            xml.item('identifier' => mod.identifier) { |xml|
              xml.title mod.title
            }
          end
        }
      end
    }
  end

  def resources(xml, resources)
    xml.resources { |xml|
      course_setting_resource(xml)
      resources.each do |resource|
        xml.resource(resource.attributes) do |xml|
          resource.files.each { |file| xml.file(href: file) }
        end
      end
    }
  end

  def course_setting_resource(xml)
    course_setting_dir = Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR
    export_file = File.join(course_setting_dir, Moodle2CC::CanvasCC::CanvasExportWriter::CANVAS_EXPORT_FILE)
    course_setting_file = File.join(course_setting_dir, Moodle2CC::CanvasCC::CourseSettingWriter::COURSE_SETTINGS_FILE)
    module_meta_file = File.join(course_setting_dir, Moodle2CC::CanvasCC::ModuleMetaWriter::MODULE_META_FILE)
    xml.resource('identifier' => @course.identifier + SETTINGS_POSTFIX, 'type' => TYPE_LAR, 'href' => export_file) { |xml|
      xml.file('href' => course_setting_file)
      xml.file('href' => module_meta_file) if @course.canvas_modules.count > 0
    }
  end


end