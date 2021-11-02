require 'rails_helper'
require_relative '../support/matchers/custom_cancan'

describe Canard::Abilities, '#users' do
  let(:acting_user) { FactoryGirl.create(:user, :player) }

  subject(:user_ability) { Ability.new(acting_user) }

  describe 'on User' do
    let(:user) { FactoryGirl.create(:user, :player) }

    it { is_expected.to be_able_to(:show, acting_user) }
    it { is_expected.to be_able_to(:edit, acting_user) }
    it { is_expected.to be_able_to(:update, acting_user) }
    it { is_expected.to_not be_able_to(:manage, user) }
    it { is_expected.to_not be_able_to(:destroy, user) }
  end
  # on User
end
