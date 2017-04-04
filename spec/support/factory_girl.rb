RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # Spring doesn't reload factory_girl
  config.before(:all) do
    FactoryGirl.reload
  end
end
