require 'administrate/base_dashboard'

class WorkoutDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    phase: Field::BelongsTo,
    phase_id: PhaseSelectField.with_options(
      value_method: 'id',
      text_method: 'name',
    ),
    name: Field::String,
    supplemental: Field::Boolean,
    pyramid_module_name: PyramidModuleNameField,
    exercise_workouts: Field::HasMany,
    exercises: Field::NestedHasMany.with_options(
      skip: [:workout],
      limit: 30,
    ),
    exercises_multi_select: Field::CollectionSelect.with_options(
      ids: :exercise_ids,
      collection: proc { Exercise.all },
      value_method: :id,
      text_method: :name,
      options: {
        include_blank: false,
        include_hidden: false,
      },
      multiple: true,
      label: 'Exercises',
    ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    position: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :position,
    :name,
    :pyramid_module_name,
    :phase,
    :supplemental,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :phase,
    :name,
    :supplemental,
    :exercises,
    :exercise_workouts,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :pyramid_module_name,
    :phase_id,
    :name,
    :supplemental,
    :exercises_multi_select,
  ].freeze

  # Overwrite this method to customize how workouts are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(workout)
    workout.name
  end
end
