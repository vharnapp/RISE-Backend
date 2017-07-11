module AdministrateResourcesHelper
    # NOTE: (2017-06-06) jon => Not sure why all routes show up as "resources"
    #
    # put 'sort' => 'application#sort'
    #
    def resources_to_ignore
      %w[application workouts phases affiliations enrollments temp_teams unlocked_pyramid_modules]
    end

    def resources_for_sidebar_nav
      Administrate::Namespace
        .new(:admin)
        .resources
        .reject do |resource_obj|
          resources_to_ignore.include?(resource_obj.resource)
        end
    end
end
