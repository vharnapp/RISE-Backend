Canard::Abilities.for(:user) do
  can [:show, :edit, :update, :analytics_alias], User do |u|
    u == user
  end
  cannot [:destroy], User
  cannot [:index], User

  can :read, PyramidModule
  can :read, Phase
  can :read, Workout
  can :read, Exercise

  can :manage, ConfidenceRating do |cr|
    cr.user == user
  end
  can :create, ConfidenceRating

  can :manage, UnlockedPyramidModule do |upm|
    upm.user == user
  end
  can :create, UnlockedPyramidModule
end
