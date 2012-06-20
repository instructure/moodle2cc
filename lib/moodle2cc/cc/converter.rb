module Moodle2CC::CC
  class Converter
    include CCHelper

    def initialize(moodle_backup, export_dir)
      @moodle_backup = moodle_backup
      @export_dir = export_dir
    end

    def imscc_path
      @imscc_path ||= ::File.join(@export_dir, "#{@moodle_backup.course.fullname.downcase.gsub(/\s/, '_')}.imscc")
    end

    def convert
      ::File.open(::File.join(@export_dir, MANIFEST), 'w') do |file|
        @document = Builder::XmlMarkup.new(:target => file, :indent => 2)
        @document.instruct!
        create_manifest
      end
      Zip::ZipFile.open(imscc_path, Zip::ZipFile::CREATE) do |zipfile|
        Dir["#{@export_dir}/**/*"].each do |file|
          zipfile.add(file.sub(@export_dir + '/', ''), file)
        end
      end
    end

    def create_manifest
      @document.manifest(
        "identifier" => create_key(@moodle_backup.course.id, "common_cartridge_"),
        "xmlns" => "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1",
        "xmlns:lom" => "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource",
        "xmlns:lomimscc" => "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imscp_v1p2_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lomresource_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lommanifest_v1p0.xsd"
      ) do |manifest_node|
        @manifest_node = manifest_node
        @manifest_node.metadata do |md|
          md.schema "IMS Common Cartridge"
          md.schemaversion "1.1.0"
          md.lomimscc :lom do |lom|
            lom.lomimscc :general do |general|
              general.lomimscc :title do |title|
                title.lomimscc :string, @moodle_backup.course.fullname
              end
            end
            lom.lomimscc :lifeCycle do |lifecycle|
              lifecycle.lomimscc :contribute do |contribute|
                contribute.lomimscc :date do |date|
                  date.lomimscc :dateTime, ims_date
                end
              end
            end
            lom.lomimscc :rights do |rights|
              rights.lomimscc :copyrightAndOtherRestrictions do |node|
                node.lomimscc :value, 'yes'
              end
              rights.lomimscc :description do |desc|
                desc.lomimscc :string, 'Private (Copyrighted) - http://en.wikipedia.org/wiki/Copyright'
              end
            end
          end
        end

        create_organizations
      end
    end

    def create_organizations
      @manifest_node.organizations do |orgs|
        orgs.organization(
          :identifier => 'org_1',
          :structure => 'rooted-hierarchy'
        ) do |org|
          org.item(:identifier => "LearningModules") do |root_item|
            @moodle_backup.course.sections.each do |section|
              root_item.item(:identifier => CCHelper.create_key(section.id, "section_")) do |item|
                item.title "week #{section.number}"
                section.mods.each do |mod|
                  item.item(:identifier => CCHelper.create_key(mod.instance_id, "mod_")) do |sub_item|
                    title = case mod.instance.mod_type
                            when 'assignment', 'resource', 'forum'
                              mod.instance.name
                            when 'label'
                              mod.instance.content
                            end
                    sub_item.title title
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
