require 'administrate/base_dashboard'

class ExerciseDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    description: Field::Text.with_options(
      searchable: true,
    ),
    sets: Field::String,
    reps: Field::String,
    rest: Field::String,
    video: PaperclipVideoField,
    keyframe: Field::Paperclip.with_options(
      big_style: :medium,
    ),
    workouts: Field::NestedHasMany.with_options(
      skip: [:exercise],
      limit: 30,
    ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :workouts,
    :description,
    :sets,
    :reps,
    :rest,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :description,
    :sets,
    :reps,
    :rest,
    :keyframe,
    :video,
    :workouts,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :sets,
    :reps,
    :rest,
    :keyframe,
    :video,
  ].freeze

  # Overwrite this method to customize how exercises are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(exercise)
    exercise.name
  end
end
