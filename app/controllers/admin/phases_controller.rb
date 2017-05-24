module Admin
  class PhasesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Phase.
    #     page(params[:page]).
    #     per(10)
    # end

    def new
      phase = resource_class.new
      3.times { phase.workouts.build }
      render locals: {
        page: Administrate::Page::Form.new(dashboard, phase),
      }
    end

    def edit
      phase = requested_resource
      3.times { phase.workouts.build } if phase.workouts.blank?
      render locals: {
        page: Administrate::Page::Form.new(dashboard, phase),
      }
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Phase.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
