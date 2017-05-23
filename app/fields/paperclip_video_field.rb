require 'administrate/field/base'

class PaperclipVideoField < Administrate::Field::Base
  def to_s
    data
  end
end
