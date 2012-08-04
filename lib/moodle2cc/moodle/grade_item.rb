module Moodle2CC::Moodle
  class GradeItem
    include HappyMapper
    
    PROPERTIES = %w{id category_id item_name item_type item_module item_instance 
                    item_number grade_type grade_max grade_min scale_id}

    attr_accessor :course

    tag 'GRADEBOOK/GRADE_ITEMS/GRADE_ITEM'
    element :id, Integer, :tag => 'ID'
    element :category_id, Integer, :tag => 'CATEGORYID'
    element :item_name, String, :tag => 'ITEMNAME'
    element :item_type, String, :tag => 'ITEMTYPE'
    element :item_module, String, :tag => 'ITEMMODULE'
    element :item_instance, Integer, :tag => 'ITEMINSTANCE'
    element :item_number, Integer, :tag => 'ITEMNUMBER'
    element :grade_type, Integer, :tag => 'GRADETYPE'
    element :grade_max, Float, :tag => 'GRADEMAX'
    element :grade_min, Float, :tag => 'GRADEMIN'
    element :scale_id, Integer, :tag => 'SCALEID'

    def instance
      course.mods.find { |mod| mod.id == item_instance }
    end
  end
end
