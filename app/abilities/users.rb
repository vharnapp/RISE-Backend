Canard::Abilities.for(:user) do
  can [:show, :edit, :update], User do |u|
    u == user
  end
  cannot [:destroy], User
  cannot [:index], User
end
