class UsersController < ApplicationController
  load_resource
  authorize_resource except: [:analytics_alias]
  skip_authorization_check only: [:analytics_alias]

  def analytics_alias
    # view file has JS that will identify the anonymous user through segment
    # after registration via "after devise registration path"
  end
end
