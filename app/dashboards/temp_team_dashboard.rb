require 'administrate/base_dashboard'

class TempTeamDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    num_players: Field::Number,
    coach_first_name: Field::String,
    coach_last_name: Field::String,
    coach_email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :num_players,
    :coach_first_name,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :num_players,
    :coach_first_name,
    :coach_last_name,
    :coach_email,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :num_players,
    :coach_first_name,
    :coach_last_name,
    :coach_email,
  ].freeze

  # Overwrite this method to customize how temp teams are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(temp_team)
  #   "TempTeam ##{temp_team.id}"
  # end
end
