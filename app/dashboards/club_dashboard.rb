require 'administrate/base_dashboard'

class ClubDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    welcome_message: Field::Text,
    club_affiliations: Field::HasMany,
    administrators: Field::HasMany.with_options(
      class_name: 'User',
      limit: 30,
    ),
    subscriptions: Field::NestedHasMany.with_options(
      skip: [:club, :teams, :user],
      limit: 30,
      sortable: false,
      sort_by: 'end_date', # TODO: (2017-07-24) jon => implement me, copy from Field::HasMany
      direction: 'desc',   # TODO: (2017-07-24) jon => implement me, copy from Field::HasMany
    ),
    teams: Field::HasMany.with_options(
      sortable: false,
      limit: 50,
      sort_by: 'name',
    ),
    temp_teams: Field::NestedHasMany.with_options(
      skip: [:club],
      limit: 30,
    ),
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    slug: Field::String,
    deleted_at: Field::DateTime,
    position: Field::Number,
    logo: Field::Carrierwave.with_options(
      image_on_index: true,
      sortable: false,
    ),
    contact_first_name: Field::String,
    contact_last_name: Field::String,
    contact_email: Field::String,
    contact_phone: Field::String,
    address_line1: Field::String,
    address_line2: Field::String,
    address_city: Field::String,
    address_state: Field::String,
    address_zip: Field::String,
    teams_csv: Field::Carrierwave,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :logo,
    :name,
    :teams,
    :subscriptions,
    :contact_phone,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :logo,
    :name,
    :welcome_message,
    :contact_first_name,
    :contact_last_name,
    :contact_email,
    :contact_phone,
    :address_line1,
    :address_line2,
    :address_city,
    :address_state,
    :address_zip,
    :administrators,
    :subscriptions,
    :teams,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :logo,
    :name,
    :welcome_message,
    :administrators,
    :contact_first_name,
    :contact_last_name,
    :contact_email,
    :contact_phone,
    :address_line1,
    :address_line2,
    :address_city,
    :address_state,
    :address_zip,
    :teams_csv,
    :subscriptions,
    :temp_teams,
  ].freeze

  # Overwrite this method to customize how clubs are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(club)
    club.name
  end
end
