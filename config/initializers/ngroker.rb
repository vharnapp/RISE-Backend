if Rails.const_defined?('Server') && Rails.env.development? && ENV['NGROK'] == 'true'
  require 'ngroker'
  include Ngroker
  ENV['NGROK_URL'] = Ngroker.url
end
