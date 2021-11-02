module RenderJsonUserWithToken
  extend ActiveSupport::Concern

  def render_json_user_with_token(user, return_user: true)
    token = Tiddle.create_and_return_token(user, request)

    if return_user
      user_json =
        JSONAPI::ResourceSerializer
          .new(Api::V1::UserResource)
          .serialize_to_hash(Api::V1::UserResource.new(user, nil))
    end

    token_json = {
      meta: {
        authentication_token: token,
        user_id: user.id,
      },
    }

    json = token_json
    json = json.merge(user_json) if return_user

    render json: json, status: :ok
  end
end
