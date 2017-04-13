module HttpHelpers
  def authenticate(user)
    request = double(remote_ip: '127.0.0.1', user_agent: 'RSpec')
    @user = user
    @authentication_token = Tiddle.create_and_return_token(user, request)
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
    {
      'X-User-Email' => @user.email,
      'X-User-Token' => @authentication_token,
    }
  end
end

RSpec.configure do |config|
  config.include HttpHelpers
end
