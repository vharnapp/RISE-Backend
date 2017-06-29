require 'administrate/base_dashboard'

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    authentication_tokens: Field::HasMany,
    affiliations: Field::HasMany,
    teams: Field::HasMany,
    confidence_ratings: Field::HasMany,
    exercises: Field::HasMany,
    workouts: Field::HasMany,
    unlocked_pyramid_modules: Field::HasMany,
    phase_attempts: Field::HasMany,
    phases: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    uuid: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    roles_mask: Field::Number,
    role_list: Field::String,
    slug: Field::String,
    deleted_at: Field::DateTime,
    nickname: Field::String,
    avatar: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :avatar,
    :first_name,
    :last_name,
    :email,
    :nickname,
    :role_list,
    :teams,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :avatar,
    :first_name,
    :last_name,
    :email,
    :nickname,
    :unlocked_pyramid_modules,
    :role_list,
    :teams,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :nickname,
    :email,
    :teams,
    :unlocked_pyramid_modules,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user.full_name
  end
end
