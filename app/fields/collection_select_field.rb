require 'administrate/field/base'

class CollectionSelectField < Administrate::Field::Base
  def to_s
    data
  end

  def selectable_options(f)
    f.object.phase.pyramid_module.phases
  end

  def selectable_value
    value_method
  end

  def selectable_text
    text_method
  end

  private

  def collection
    @collection ||= options.fetch(:collection, [])
  end

  def value_method
    @value_method ||= options.fetch(:value_method, nil)
  end

  def text_method
    @text_method ||= options.fetch(:text_method, nil)
  end
end
