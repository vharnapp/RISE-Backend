# rubocop:disable Metrics/LineLength
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:club) { create(:club) }

  context 'validations' do
    before do
      create(:subscription, club: club, start_date: Time.zone.today, end_date: 1.year.from_now.to_date)
    end

    it 'does not allow overlapping subscriptions for the same club' do
      sub = build(:subscription, club: club, start_date: Time.zone.today, end_date: 1.year.from_now.to_date)
      sub.valid?
      expect(sub.errors.messages[:start_date]).to include('overlaps with another record')
    end

    it 'does not allow overlapping subscriptions inside an existing date range for the same club' do
      sub = build(:subscription, club: club, start_date: 10.days.from_now, end_date: 1.year.from_now - 10.days)
      sub.valid?
      expect(sub.errors.messages[:start_date]).to include('overlaps with another record')
    end

    it 'does allow a subscription to start the next day after a current one ends for the same club' do
      sub = build(:subscription, club: club, start_date: 1.year.from_now + 1.day, end_date: 1.year.from_now + 2.days)
      expect(sub).to be_valid
    end

    it 'allows overlapping subscriptions for different clubs' do
      sub = build(:subscription, club: create(:club), start_date: Time.zone.today, end_date: 1.year.from_now.to_date)
      expect(sub).to be_valid
    end
  end

  context 'scopes' do
    context 'present time' do
      context 'subscription ended yesterday' do
        let(:subscription) do
          create(:subscription, club: club, start_date: 1.year.ago + 1.day, end_date: 1.day.ago)
        end

        it '.current is empty' do
          expect(Subscription.current).to be_empty
        end
      end

      context 'subscription started today and ends 1 year from now' do
        let(:subscription) do
          create(:subscription, club: club, start_date: Time.zone.today, end_date: 1.year.from_now)
        end

        it '.current contains the subscription' do
          expect(Subscription.current).to eq([subscription])
        end
      end

      context 'subscription started 6 months ago and ends 6 months from now' do
        before do
          travel_to 6.months.ago do
            @subscription = create(:subscription, club: club, start_date: Date.today, end_date: 1.year.from_now)
          end
        end

        it '.current contains the subscription' do
          expect(Subscription.current).to eq([@subscription])
        end
      end

      context 'subscription ends today and started 1 year ago' do
        before do
          travel_to 1.year.ago do
            @subscription = create(:subscription, club: club, start_date: Date.today, end_date: 1.year.from_now)
          end
        end

        it '.current contains the subscription' do
          expect(Subscription.current).to eq([@subscription])
        end

        context 'a second subscription is slated to start tomorrow' do
          let!(:subscription_starting_tomorrow) do
            create(:subscription, club: club, start_date: 1.day.from_now, end_date: 1.year.from_now + 1.day)
          end

          it '.current DOES NOT contain this new subscription' do
            expect(Subscription.current).to eq([@subscription])
          end

          context 'tomorrow' do
            it '.current ONLY contains this new scription' do
              travel_to 1.day.from_now do
                expect(Subscription.current).to eq([subscription_starting_tomorrow])
              end
            end
          end
        end
      end
    end

    context 'future - 1 year and 1 day from now' do
      context 'subscription ended yesterday' do
        let(:subscription) do
          create(:subscription, club: club, start_date: Time.zone.today, end_date: 1.year.from_now)
        end

        it '.current is empty' do
          travel_to 1.year.from_now + 1.day do
            expect(Subscription.current).to be_empty
          end
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: subscriptions
#
#  club_id    :integer
#  created_at :datetime         not null
#  end_date   :date
#  id         :integer          not null, primary key
#  price      :decimal(, )
#  start_date :date
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_club_id  (club_id)
#
