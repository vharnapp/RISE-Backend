Canard::Abilities.for(:player) do
  can [:show, :edit, :update], User, id: user.id
  cannot [:destroy], User
  cannot [:index], User

  can :read, Snippet
  can :read, PyramidModule
  can :read, Phase
  can :read, Workout
  can :read, Exercise
  can :read, Club do |club|
    club.players.include?(user)
  end
  can :read, Team do |team|
    team.players.include?(user)
  end

  can :manage, ConfidenceRating, user_id: user.id
  can :create, ConfidenceRating

  can :manage, UnlockedPyramidModule, user_id: user.id
  can :create, UnlockedPyramidModule

  can :manage, PhaseAttempt, user_id: user.id
  can :create, PhaseAttempt

  can [:update, :destroy], Affiliation, user_id: user.id
  can [:create], Affiliation
end
