require 'administrate/base_dashboard'

class AffiliationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    team: Field::BelongsTo,
    id: Field::Number,
    coach: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    deleted_at: Field::DateTime,
    position: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :team,
    :coach,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :team,
    :coach,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :team,
    :coach,
  ].freeze

  # Overwrite this method to customize how affiliations are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(affiliation)
  #   "Affiliation ##{affiliation.id}"
  # end
end
