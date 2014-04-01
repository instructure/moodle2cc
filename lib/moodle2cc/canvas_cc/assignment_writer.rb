module Moodle2CC::CanvasCC
  class AssignmentWriter

    def initialize(work_dir, *assignments)
      @work_dir = work_dir
      @assignments = assignments
    end

    def write
      @assignments.each do |assignment|
        assignment_dir = File.join(@work_dir, assignment.assignment_resource.identifier)
        Dir.mkdir(assignment_dir)
        write_html(assignment_dir, assignment)
        write_settings(assignment_dir, assignment)
      end
    end

    private

    def write_settings(assignment_dir, assignment)
      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.assignment('identifier' => assignment.assignment_resource.identifier,
                       'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
                       'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                       'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
        ) { |xml|
          xml.title assignment.title
          xml.due_at Moodle2CC::CC::CCHelper.ims_datetime(assignment.due_at) if assignment.due_at
          xml.lock_at Moodle2CC::CC::CCHelper.ims_datetime(assignment.lock_at) if assignment.lock_at
          xml.unlock_at Moodle2CC::CC::CCHelper.ims_datetime(assignment.unlock_at) if assignment.unlock_at
          xml.all_day_date Moodle2CC::CC::CCHelper.ims_datetime(assignment.all_day_date) if assignment.all_day_date
          xml.peer_reviews_due_at Moodle2CC::CC::CCHelper.ims_datetime(assignment.peer_reviews_due_at) if assignment.peer_reviews_due_at
          xml.assignment_group_identifierref assignment.assignment_group_identifier_ref if assignment.assignment_group_identifier_ref
          xml.workflow_state assignment.workflow_state if assignment.workflow_state
          xml.points_possible assignment.points_possible if assignment.points_possible
          xml.grading_type assignment.grading_type if assignment.grading_type
          xml.all_day assignment.all_day unless assignment.all_day.nil?
          xml.submission_types assignment.submission_types.join(',') unless assignment.submission_types.empty?
          xml.position assignment.position if assignment.position
          xml.peer_review_count assignment.peer_review_count if assignment.peer_review_count
          xml.peer_reviews_assigned assignment.peer_reviews_assigned unless assignment.peer_reviews_assigned.nil?
          xml.peer_reviews assignment.peer_reviews unless assignment.peer_reviews.nil?
          xml.automatic_peer_reviews assignment.automatic_peer_reviews unless assignment.automatic_peer_reviews.nil?
          xml.grade_group_students_individually assignment.grade_group_students_individually unless assignment.grade_group_students_individually.nil?
        }
      end.to_xml
      File.open(File.join(assignment_dir, Moodle2CC::CanvasCC::Models::Assignment::ASSIGNMENT_SETTINGS_FILE), 'w') { |f| f.write(xml) }
    end


    def write_html(assignment_dir, assignment)
      builder = Nokogiri::HTML::Builder.new(:encoding => 'UTF-8') do |doc|
        doc.html { |html|
          html.head { |head|
            head.meta('http-equiv' => 'Content-Type', content: 'text/html; charset=utf-8')
            head.title "Assignment: #{assignment.title}"
          }
          html.body { |body|
            body << Nokogiri::HTML::fragment(assignment.body)
          }
        }
      end
      File.open(File.join(@work_dir, assignment.assignment_resource.href), 'w') { |f| f.write(builder.to_html) }
    end

  end
end