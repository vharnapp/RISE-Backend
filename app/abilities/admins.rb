Canard::Abilities.for(:admin) do
  can :manage, :all

  can [:destroy], User
end
