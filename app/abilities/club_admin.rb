Canard::Abilities.for(:club_admin) do
  includes_abilities_of :coach

  can [:read], Club do |club|
    user.clubs_administered.include?(club)
  end

  can [:read], Team do |team|
    user.clubs_administered.flat_map(&:teams).include?(team)
  end

  can :destroy, Affiliation do |a|
    user.clubs_administered.flat_map(&:players).include?(a.user)
  end

  can :show, User do |u|
    (user.clubs_administered.flat_map(&:players) +
      user.clubs_administered.flat_map(&:coaches)
    ).include?(u)
  end
end
