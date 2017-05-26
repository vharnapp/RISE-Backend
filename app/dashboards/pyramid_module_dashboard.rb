require 'administrate/base_dashboard'

class PyramidModuleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    track: EnumField,
    level: Field::SelectBasic.with_options(
      choices: [1,2,3,4,5],
      # choices: [['Level 1', 1],['Level 2', 2],['Level 3', 3],['Level 4', 4],['Level 5', 5]],
    ),
    prereq: PyramidModuleMultiSelectField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    video: PaperclipVideoField,
    keyframe: KeyframeField,
    phases: Field::NestedHasMany.with_options(
      skip: [:pyramid_module, :workouts],
      limit: 10,
    ),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :description,
    :track,
    :level,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :description,
    :track,
    :level,
    :prereq,
    :keyframe,
    :video,
    :phases,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :track,
    :level,
    :prereq,
    :keyframe,
    :video,
    :phases,
  ].freeze

  # Overwrite this method to customize how pyramid modules are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(pyramid_module)
    pyramid_module.name
  end
end
