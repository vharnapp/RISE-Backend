require 'rails_helper'

RSpec.describe ConfidenceRating, type: :model do
  context 'day streak' do
    context 'latest rating is today' do
      it 'calculates number of concecutive days with a rating per user' do
        first_user = create(:user)
        second_user = create(:user)

        # TODAY
        create(:confidence_rating, user: first_user)
        create(:confidence_rating, user: first_user)
        create(:confidence_rating, user: first_user)
        create(:confidence_rating, user: second_user)
        create(:confidence_rating, user: second_user)
        create(:confidence_rating, user: second_user)

        # YESTERDAY
        travel_to 1.day.ago do
          create(:confidence_rating, user: first_user)
          create(:confidence_rating, user: first_user)
          create(:confidence_rating, user: second_user)
          create(:confidence_rating, user: second_user)
        end

        travel_to 2.days.ago do
          create(:confidence_rating, user: first_user)
          create(:confidence_rating, user: first_user)
          # Streak ends for second_user
        end

        (5..9).each do |n|
          travel_to n.days.ago do
            create(:confidence_rating, user: first_user)
            create(:confidence_rating, user: second_user)
          end
        end

        expect(first_user.day_streak).to eq(3)
        expect(second_user.day_streak).to eq(2)
      end
    end

    context 'latest rating is yesterday' do
      it 'calculates number of concecutive days with a rating per user' do
        first_user = create(:user)
        second_user = create(:user)

        # YESTERDAY
        travel_to 1.day.ago do
          create(:confidence_rating, user: first_user)
          create(:confidence_rating, user: second_user)
        end

        travel_to 2.days.ago do
          create(:confidence_rating, user: first_user)
          # Streak ends for second_user
        end

        (5..9).each do |n|
          travel_to n.days.ago do
            create(:confidence_rating, user: first_user)
            create(:confidence_rating, user: second_user)
          end
        end

        expect(first_user.day_streak).to eq(2)
        expect(second_user.day_streak).to eq(1)
      end
    end

    context 'latest rating was 2 days ago and they had a 4 day streak at that time' do
      it 'displays 0 for the current streak' do
        first_user = create(:user)

        (2..5).each do |n|
          travel_to n.days.ago do
            create(:confidence_rating, user: first_user)
          end
        end

        expect(first_user.day_streak).to eq(0)
      end
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
