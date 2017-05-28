module Admin
  class PyramidModulesController < Admin::ApplicationController
    include DefaultSort

    def new
      pyramid_module = resource_class.new
      3.times { pyramid_module.phases.build }
      render locals: {
        page: Administrate::Page::Form.new(dashboard, pyramid_module),
      }
    end

    private

    def resource_params
      params.require(resource_name).permit(*dashboard.permitted_attributes, prereq: [])
    end
  end
end
