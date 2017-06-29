require 'administrate/base_dashboard'

class UnlockedPyramidModuleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    pyramid_module: Field::BelongsTo,
    id: Field::Number,
    completed_phases: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :pyramid_module,
    :completed_phases,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :pyramid_module,
    :completed_phases,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :pyramid_module,
    :completed_phases,
  ].freeze

  # Overwrite this method to customize how unlocked pyramid modules are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(unlocked_pyramid_module)
    unlocked_pyramid_module.pyramid_module.name
  end
end
