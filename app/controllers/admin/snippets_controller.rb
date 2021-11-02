module Admin
  class SnippetsController < Admin::ApplicationController
    include DefaultSort

    def edit
      super
    rescue ActiveRecord::RecordNotFound
      redirect_to new_admin_snippet_path(name: params[:id], content: params[:content])
    end

    def new
      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource_class.new(name: params[:name].titleize, content: params[:content])),
      }
    end

    def destroy
      requested_resource.really_destroy!
      flash[:notice] = translate_with_resource("destroy.success")
      redirect_to action: :index
    end

    def update
      requested_resource.update_column(:slug, nil)
      super
    end
  end
end
