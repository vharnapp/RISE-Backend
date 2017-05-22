require 'administrate/field/base'

class RolesField < Administrate::Field::Base
  def to_s
    data.titleize
  end
end
