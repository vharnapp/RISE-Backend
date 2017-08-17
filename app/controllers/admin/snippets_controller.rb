module Admin
  class SnippetsController < Admin::ApplicationController
    include DefaultSort

    def update
      requested_resource.update_column(:slug, nil)
      super
    end
  end
end
