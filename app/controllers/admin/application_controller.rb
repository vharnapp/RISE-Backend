# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include DefaultSort

    before_action :authenticate_admin

    def destroy
      resource_to_destroy = requested_resource
      requested_resource.destroy
      flash[:notice] = translate_with_resource('destroy.success') + " #{undo_link(resource_to_destroy)}."
      redirect_to action: :index
    end

    private

    def authenticate_admin
      txt = 'You must be an admin to perform that action'
      redirect_to root_path, alert: txt unless current_user.admin?
    end

    def undo_link(resource)
      view_context.link_to('undo', revert_version_path(resource, model: resource.class.name), method: :post)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
