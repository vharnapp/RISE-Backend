require 'administrate/base_dashboard'

class PhaseDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    pyramid_module: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    supplemental: Field::Boolean,
    video: PaperclipVideoField,
    keyframe: KeyframeField,
    workouts: Field::NestedHasMany.with_options(
      skip: [:phase_id, :pyramid_module_name, :exercises_multi_select],
      limit: 30,
    ),
    position: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :position,
    :pyramid_module,
    :supplemental,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :pyramid_module,
    :supplemental,
    :keyframe,
    :video,
    :workouts,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pyramid_module,
    :name,
    :supplemental,
    :keyframe,
    :video,
    :workouts,
  ].freeze

  # Overwrite this method to customize how phases are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(phase)
    phase.name
  end
end
