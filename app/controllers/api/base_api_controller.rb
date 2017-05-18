module Api
  class BaseApiController < ApplicationController
    include JSONAPI::Utils
    protect_from_forgery with: :null_session, prepend: true
    rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found
  end
end
