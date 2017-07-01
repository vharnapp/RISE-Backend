require 'administrate/base_dashboard'

class SubscriptionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    club: Field::BelongsTo,
    teams: Field::HasMany,
    enrollments: Field::HasMany,
    id: Field::Number,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    price: Field::String.with_options(searchable: false),
    club_fee: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :club,
    :teams,
    :start_date,
    :end_date,
    :price,
    :club_fee,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :club,
    :start_date,
    :end_date,
    :price,
    :club_fee,
    :teams,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :club,
    :start_date,
    :end_date,
    :price,
    :teams,
  ].freeze

  # Overwrite this method to customize how subscriptions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(subscription)
  #   "Subscription ##{subscription.id}"
  # end
end
