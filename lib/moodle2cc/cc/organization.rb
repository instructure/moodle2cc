module Moodle2CC::CC
  class Organization
    include CCHelper

    attr_accessor :items

    def initialize
      @items = []
    end

    def self.from_manifest(manifest)
      organization = Organization.new
      organization.items = []
      if manifest.moodle_backup.course.xpath('SECTIONS')
        manifest.moodle_backup.course.xpath('SECTIONS/SECTION').each do |section|
          organization.items << Item.from_manifest(manifest, section)
        end
      end
      organization
    end
  end
end
