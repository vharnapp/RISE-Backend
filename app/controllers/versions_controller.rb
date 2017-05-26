class VersionsController < Admin::ApplicationController
  def revert
    @resource = params[:model].constantize.only_deleted.find(params[:id])
    @resource.restore(recursive: true)
    flash[:notice] = "Restored #{params[:model]} and its nested records."
    redirect_to send("admin_#{params[:model].underscore.pluralize}_path")
  end
end
