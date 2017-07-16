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
    subscriptions: Field::HasMany,
    enrollments: Field::HasMany,
    affiliations: Field::HasMany,
    coach_affiliations: Field::HasMany.with_options(class_name: 'Affiliation'),
    player_affiliations: Field::HasMany.with_options(class_name: 'Affiliation'),
    coaches: Field::HasMany.with_options(class_name: 'User'),
    players: Field::HasMany.with_options(class_name: 'User'),
    id: Field::Number,
    num_players: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    slug: Field::String,
    deleted_at: Field::DateTime,
    position: Field::Number,
    code: Field::String,
    display_code: Field::String.with_options(
      searchable: false,
    ),
    logo: Field::Carrierwave.with_options(
      image_on_index: true,
    ),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :logo,
    :name,
    :club,
    :coaches,
    :num_players,
    :players,
    :display_code,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :logo,
    :club,
    :name,
    :display_code,
    :num_players,
    :coaches,
    :players,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :logo,
    :club,
    :name,
    :code,
    :num_players,
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
