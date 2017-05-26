module Admin
  class PyramidModulesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = PyramidModule.
    #     page(params[:page]).
    #     per(10)
    # end

    def new
      pyramid_module = resource_class.new
      3.times { pyramid_module.phases.build }
      render locals: {
        page: Administrate::Page::Form.new(dashboard, pyramid_module),
      }
    end

    def sort
      model = controller_name.classify.constantize

      params[:ids].each_with_index do |id, index|
        model.where(id: id).update(position: index + 1)
      end

      render nothing: true
    end

    def resource_params
      params.require(resource_name).permit(*dashboard.permitted_attributes, prereq: [])
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   PyramidModule.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
