module TestWikiHelper
  def pages!
    @page1 = Moodle2CC::Moodle::Mod::Page.new
    @page1.page_name = 'My Wiki'
    @page1.version = 1
    @page1.content = 'First version'

    @page2 = Moodle2CC::Moodle::Mod::Page.new
    @page2.page_name = 'My Wiki'
    @page2.version = 2
    @page2.content = 'Second version'

    @page3 = Moodle2CC::Moodle::Mod::Page.new
    @page3.page_name = 'New Page'
    @page3.version = 1
    @page3.content = 'This is a link to [My Wiki]'

    @mod.page_name = 'My Wiki'
    @mod.pages = [@page1, @page2, @page3]
  end
end
