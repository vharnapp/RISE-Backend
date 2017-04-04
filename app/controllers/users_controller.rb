class UsersController < ApplicationController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  # load_and_authorize_resource only: []
  skip_authorization_check only: [:analytics_alias]

  def analytics_alias
    # view file has JS that will identify the anonymous user through segment
    # after registration via "after devise registration path"
  end
end
