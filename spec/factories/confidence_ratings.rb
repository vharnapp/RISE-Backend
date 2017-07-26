FactoryGirl.define do
  factory :confidence_rating do
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
    rating { rand(1..4) }
    skipped false

    trait :yesterday do
      updated_at { 1.day.ago }
    end

    trait :two_days_ago do
      updated_at { 2.days.ago }
    end

    trait :three_days_ago do
      updated_at { 3.days.ago }
    end

    callback(:after_build, :after_stub, :after_create) do |model|
      workout = create(:workout)
      model.workout = workout
      exercise = create(:exercise, workouts: [workout])
      model.exercise = exercise
      model.save
    end
  end
end

# == Schema Information
#
# Table name: confidence_ratings
#
#  created_at  :datetime         not null
#  deleted_at  :datetime
#  exercise_id :integer
#  id          :integer          not null, primary key
#  rating      :integer          default(0)
#  skipped     :boolean          default(FALSE), not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  workout_id  :integer
#
# Indexes
#
#  index_confidence_ratings_on_exercise_id  (exercise_id)
#  index_confidence_ratings_on_user_id      (user_id)
#  index_confidence_ratings_on_workout_id   (workout_id)
#
