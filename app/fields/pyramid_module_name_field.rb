require 'administrate/field/base'

class PyramidModuleNameField < Administrate::Field::Base
  def to_s
    data
  end
end
