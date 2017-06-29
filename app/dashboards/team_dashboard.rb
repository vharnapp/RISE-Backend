require 'administrate/base_dashboard'

class TeamDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    club: Field::BelongsTo,
    affiliations: Field::HasMany,
    coach_affiliations: Field::HasMany.with_options(class_name: 'Affiliation'),
    player_affiliations: Field::HasMany.with_options(class_name: 'Affiliation'),
    coaches: Field::HasMany.with_options(class_name: 'User'),
    players: Field::HasMany.with_options(class_name: 'User'),
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    slug: Field::String,
    deleted_at: Field::DateTime,
    position: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :club,
    :coaches,
    :players,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :club,
    :name,
    :coaches,
    :players,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :club,
    :name,
    :coaches,
    :players,
  ].freeze

  # Overwrite this method to customize how teams are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(team)
    team.name
  end
end
