require 'administrate/field/base'

class PyramidModuleTracksSelectField < Administrate::Field::Base
  def to_s
    data
  end

  def choices
    options.fetch(:choices, []).map { |o| convert_to_array(o) }
  end

  def include_blank
    options.fetch(:include_blank, false)
  end

  def prompt
    options.fetch(:prompt, false)
  end

  def multiple
    options.fetch(:multiple, false)
  end

  private

  def convert_to_array(item)
    item.respond_to?(:each) ? [item.first, item.last] : [item, item]
  end
end
