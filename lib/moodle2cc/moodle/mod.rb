module Moodle2CC::Moodle
  class Mod
    include HappyMapper

    tag 'MODULES/MOD'
    element :id, Integer, :tag => 'ID'
    element :var1, Integer, :tag => 'VAR1'
    element :var2, Integer, :tag => 'VAR2'
    element :var3, Integer, :tag => 'VAR3'
    element :var4, Integer, :tag => 'VAR4'
    element :var5, Integer, :tag => 'VAR5'
    element :mod_type, String, :tag => 'MODTYPE'
    element :type, String, :tag => 'TYPE'
    element :name, String, :tag => 'NAME'
    element :description, String, :tag => 'DESCRIPTION'
    element :alltext, String, :tag => 'ALLTEXT'
    element :content, String, :tag => 'CONTENT'
    element :assignment_type, String, :tag => 'ASSIGNMENTTYPE'
    element :reference, String, :tag => 'REFERENCE'
    element :intro, String, :tag => 'INTRO'
    element :resubmit, Boolean, :tag => 'RESUBMIT'
    element :prevent_late, Boolean, :tag => 'PREVENTLATE'
    element :grade, Integer, :tag => 'GRADE'
    element :time_due, Integer, :tag => 'TIMEDUE'
    element :time_available, Integer, :tag => 'TIMEAVAILABLE'
  end
end
