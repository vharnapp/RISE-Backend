require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#errors_for' do
    context 'displaying errors div' do
      # rubocop:disable Metrics/LineLength
      #
      # <div class="error_notification">
      #   <div class="panel-heading">
      #     <h4 class="panel-title">3 errors prohibited this user from being saved:</h4>
      #   </div>
      #   <div class="panel-body">
      #     <ul>
      #       <li>Password can't be blank</li>
      #       <li>Password is too short (minimum is 8 characters)</li>
      #       <li>Password confirmation doesn't match Password</li>
      #     </ul>
      #   </div>
      # </div>
      #
      # rubocop:enable Metrics/LineLength
      let(:user) { build(:user, password: '') }

      before { user.valid? }

      it 'displays an errors container div' do
        expect(errors_for(user)).to include('<div class="error_notification">')
      end

      it 'displays a heading div' do
        expect(errors_for(user)).to include('<div class="panel-heading">')
      end

      it 'displays a title h4' do
        expect(errors_for(user)).to include('<h4 class="panel-title">')
      end

      it 'displays an errors count' do
        error = /\d errors prohibited this user from being saved:/
        expect(errors_for(user)).to match(error)
      end

      it 'displays errors in an unordered list inside a container div' do
        expect(errors_for(user)).to include('<div class="panel-body"><ul><li>')
      end
    end
  end
end
