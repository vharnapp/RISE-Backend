class SubscriptionsController < ApplicationController
  skip_authorization_check

  def index
  end

  def create
    # Do stripe charge and associate player with a team? Or get a one-off subscription going for them.
  end
end
