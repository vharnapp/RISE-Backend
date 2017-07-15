Canard::Abilities.for(:coach) do
  includes_abilities_of :player

  can [:read], Club do |club|
    user.teams_coached.flat_map(&:club).include?(club)
  end

  can [:read], Team do |team|
    user.teams_coached.include?(team)
  end

  can :destroy, Affiliation do |a|
    user.teams_coached.flat_map(&:players).include?(a.user)
  end

  can :show, User do |u|
    user.teams_coached.flat_map(&:players).include?(u)
  end

  can [:create, :destroy], UnlockedPyramidModule
end
