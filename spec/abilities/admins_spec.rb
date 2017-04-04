require 'rails_helper'
require_relative '../support/matchers/custom_cancan'

describe Canard::Abilities, '#admins' do
  let(:acting_admin) { FactoryGirl.create(:user, :admin) }

  subject(:admin_ability) { Ability.new(acting_admin) }

  describe 'on User' do
    let(:user) { FactoryGirl.create(:user) }

    it { is_expected.to be_able_to(:destroy, user) }
  end
  # on User
end
