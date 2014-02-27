class Moodle2CC::CanvasCC::PageWriter

  def initialize(work_dir, *pages)
    @work_dir = work_dir
    @pages = pages
  end

  def write
    Dir.mkdir(File.join(@work_dir, Moodle2CC::CanvasCC::Model::Page::WIKI_CONTENT))
    @pages.each { |page| write_html(page) }
  end


  private

  def write_html(page)
    builder = Nokogiri::HTML::Builder.new do |doc|
      doc.html { |html|
        html.head { |head|
          head.meta('http-equiv' => 'Content-Type', content: 'text/html; charset=utf-8')
          head.meta(name: 'identifier', content: page.identifier)
          head.meta(name: 'editing_roles', content: page.editing_roles)
          head.meta(name: 'workflow_state', content: page.workflow_state)
          head.title page.title
        }
        html.body { |body|
          body << Nokogiri::HTML::fragment(page.body)
        }
      }
    end
    File.open(File.join(@work_dir, page.href), 'w') { |f| f.write(builder.to_html) }
  end

end