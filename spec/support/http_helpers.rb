module HttpHelpers
  def authenticate(user, scopes: 'public')
    @doorkeeper_app ||= Doorkeeper::Application.last

    @access_token =
      Doorkeeper::AccessToken.create!(
        application_id: @doorkeeper_app.id,
        resource_owner_id: user.id,
        scopes: scopes,
      )
  end

  def authed_get(endpoint, opts = {})
    headers = auth_header
    headers.merge!(opts[:headers]) if opts[:headers]
    get endpoint,
        headers: headers,
        params: opts[:params],
        xhr: true
  end

  def authed_post(endpoint, opts = {})
    headers = auth_header
    headers.merge!(opts[:headers]) if opts[:headers]
    post endpoint,
         params: opts,
         headers: headers,
         xhr: true,
         as: :json
  end

  def authed_patch(endpoint, opts = {})
    headers = auth_header
    headers.merge!(opts[:headers]) if opts[:headers]
    patch endpoint,
          params: opts,
          headers: headers,
          xhr: true,
          as: :json
  end

  def authed_delete(endpoint, opts = {})
    headers = auth_header
    headers.merge!(opts[:headers]) if opts[:headers]
    delete endpoint,
           headers: headers,
           xhr: true,
           as: :json
  end

  private

  def auth_header
    { 'Authorization' => "Bearer #{@access_token.token}" }
  end
end

RSpec.configure do |config|
  config.include HttpHelpers

  config.before(:suite) do
    Doorkeeper::Application.create!(
      name: 'MyApp',
      redirect_uri: 'https://host.name/oauth/callback',
    )
  end
end
