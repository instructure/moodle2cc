class Moodle2CC::Moodle2::FileParser

  FILES_XML = 'files.xml'
  NULL_XML_VALUE = '$@NULL@$'

  def initialize(work_dir)
    @work_dir = work_dir
  end

  def parse
    xml = Nokogiri::XML(File.read(File.join(@work_dir, FILES_XML)))
    file_nodes = xml./('files/file')
    file_nodes.map do |node|
      file = Moodle2CC::Moodle2::Model::Moodle2File.new
      file.id = node.at_xpath('@id').value
      file.content_hash = parse_text(node, 'contenthash')
      file.context_id = parse_text(node, 'contextid')
      file.component = parse_text(node, 'component')
      file.file_area = parse_text(node, 'filearea')
      file.item_id = parse_text(node, 'itemid')
      file.file_path = parse_text(node, 'filepath')
      file.file_name = parse_text(node, 'filename')
      file.user_id = parse_text(node, 'userid')
      file.file_size = parse_text(node, 'filesize')
      file.mime_type = parse_text(node, 'mimetype')
      file.status = parse_text(node, 'status')
      file.time_created = parse_text(node, 'timecreated')
      file.time_modified = parse_text(node, 'timemodified')
      file.source = parse_text(node, 'source')
      file.author = parse_text(node, 'author')
      file.license = parse_text(node, 'license')
      file.sort_order = parse_text(node, 'sortorder')
      file.repository_type = parse_text(node, 'repositorytype')
      file.repository_id = parse_text(node, 'repositoryid')
      file.reference = parse_text(node, 'reference')
      file
    end
  end


  def parse_text(node, xpath)
    if v_node = node.%(xpath)
      value = v_node.text
      value unless value == NULL_XML_VALUE
    end
  end

end