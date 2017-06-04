module Admin
  class WorkoutsController < Admin::ApplicationController
    include DefaultSort

    def create
      resource = resource_class.new(resource_params.except(:exercise))

      if resource.save
        add_new_exercise(resource)
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def update
      if requested_resource.update(resource_params.except(:exercise))
        add_new_exercise(requested_resource)
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end

    private

    def add_new_exercise(workout)
      exercise_params = params.permit!['workout']['exercise']
      if exercise_params.present?
        if exercise_params.values.map(&:present?).uniq.include?(true)
          exercise = Exercise.new(exercise_params)
          if exercise.save
            workout.exercises << exercise

            redirect_to_workout_show(workout, action_name)
          else
            error_messages = exercise.errors.full_messages.join(', ')
            action_word = action_name == 'update' ? 'updated' : 'created'
            error_text = %(
              Workout successfully #{action_word}. However, there was a problem
              creating and associating the new exercise to this workout:
              #{error_messages}
            ).squish
            flash[:error] = error_text
            redirect_to edit_admin_workout_path(workout)
          end
        else
          redirect_to_workout_show(workout, action_name)
        end
      else
        redirect_to_workout_show(workout, action_name)
      end
    end

    def redirect_to_workout_show(workout, action_name)
      redirect_to(
        edit_admin_workout_path(workout),
        notice: translate_with_resource("#{action_name}.success"),
      )
    end

    # FIXME: (2017-06-04) jon => potentially do the splat technique here
    # instead of manually listing _all_ of them.
    def resource_params
      params.require(:workout).permit(
        :name,
        :phase_id,
        exercise: [
          :name,
          :description,
          :sets,
          :reps,
          :rest,
          :keyframe,
          :video,
          :_destroy,
          :id,
        ],
        exercise_ids: [],
      )
    end
  end
end
