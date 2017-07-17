module Admin
  module ApplicationHelper
    include AdministrateResourcesHelper

    def sanitized_order_params
      resources =
        Administrate::Namespace.new(:admin).
          resources.
          map(&:resource).
          map(&:to_sym) + [:players, :coaches, :available_pyramid_modules]

      params.permit(
        *resources,
        :search,
        :id,
        :order,
        :page,
        :per_page,
        :direction,
      )
    end
  end
end
