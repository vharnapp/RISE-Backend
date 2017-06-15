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
end
