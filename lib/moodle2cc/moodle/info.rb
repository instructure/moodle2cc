module Moodle2CC::Moodle
  class Info
    include HappyMapper

    tag 'INFO'
    element :name, String, :tag => 'NAME'
  end
end
