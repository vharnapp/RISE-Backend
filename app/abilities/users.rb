Canard::Abilities.for(:user) do
  can [:manage], User do |u|
    u == user
  end
  cannot [:destroy], User
end
