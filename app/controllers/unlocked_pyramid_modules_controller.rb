class UnlockedPyramidModulesController < ApplicationController
  load_and_authorize_resource

  def create
    @unlocked_pyramid_module = UnlockedPyramidModule.new(unlocked_pyramid_module_params)
    @unlocked_pyramid_module.save
    render json: {
      unlocked_pyramid_module_id: @unlocked_pyramid_module.id,
    }
  end

  def destroy
    @unlocked_pyramid_module.destroy
    render json: {
      unlocked_pyramid_module_id: nil,
    }
  end

  private

  def unlocked_pyramid_module_params
    params.permit(
      :user_id,
      :pyramid_module_id,
      :unlocked_pyramid_module_id,
    )
  end
end
