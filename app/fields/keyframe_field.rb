require 'administrate/field/base'

class KeyframeField < Administrate::Field::Base
  def to_s
    data
  end
end
