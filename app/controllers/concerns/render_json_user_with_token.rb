module RenderJsonUserWithToken
  extend ActiveSupport::Concern

  def render_json_user_with_token(user)
    token = Tiddle.create_and_return_token(user, request)
    json =
      JSONAPI::ResourceSerializer
        .new(Api::V1::UserResource)
        .serialize_to_hash(Api::V1::UserResource.new(user, nil))

    token_json = {
      meta: {
        authentication_token: token,
      },
    }

    render json: token_json.merge(json), status: :ok
  end
end
