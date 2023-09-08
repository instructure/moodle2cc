module Moodle2CC::CanvasCC
  class QuestionBankWriter

    def initialize(work_dir, *question_banks)
      @work_dir = work_dir
      @question_banks = question_banks
    end

    def write
      @question_banks.each do |bank|
        write_bank(bank)
      end
    end

    private

    def write_bank(bank)
      bank_resource = bank.question_bank_resource

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.questestinterop("xmlns" => "http://www.imsglobal.org/xsd/ims_qtiasiv1p2",
          "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
          "xsi:schemaLocation"=> "http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd"
        ) { |xml|
          xml.objectbank(:ident => bank_resource.identifier) { |xml|
            xml.qtimetadata { |xml|
              xml.qtimetadatafield { |xml|
                xml.fieldlabel 'bank_title'
                xml.fieldentry bank.title
              }
            }
            bank.questions.each do |question|
              Moodle2CC::CanvasCC::QuestionWriter.write_question(xml, question)
            end
          }
        }
      end.to_xml

      file_path = File.join(@work_dir, bank_resource.href)
      FileUtils.mkdir_p(File.dirname(file_path)) unless File.exist?(File.dirname(file_path))
      File.open(file_path, 'w') { |f| f.write(xml) }
    end
  end
end