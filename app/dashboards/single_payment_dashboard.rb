require 'administrate/base_dashboard'

class SinglePaymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    price: Field::String,
    thank_you_link: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    pyramid_modules: Field::HasMany.with_options(
      sort_by: 'position',
      direction: 'asc',
      label: 'Pista',
      limit: 20,
    )
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :price,
    :thank_you_link,
    :pyramid_modules,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :price,
    :thank_you_link,
    :pyramid_modules,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :price,
    :thank_you_link,
    :pyramid_modules,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(single_payment)
    single_payment.name
  end
end
