module Admin
  class WorkoutsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Workout.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Workout.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def resource_params
      params.require(:workout).permit(
        :name,
        :phase_id,
        exercises_attributes: [
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
