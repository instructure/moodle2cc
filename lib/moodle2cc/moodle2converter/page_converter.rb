class Moodle2CC::Moodle2Converter::PageConverter

  def convert(moodle_page)
    canvas_page = Moodle2CC::CanvasCC::Model::Page.new
    canvas_page.identifier = moodle_page.id
    canvas_page.page_name = moodle_page.name
    canvas_page.workflow_state = 'active'
    canvas_page.editing_roles = 'teachers'
    canvas_page.body = update_links(moodle_page.content)
    canvas_page
  end

  private

  def update_links(content)
    content.gsub('@@PLUGINFILE@@', '%24IMS_CC_FILEBASE%24')
  end

end