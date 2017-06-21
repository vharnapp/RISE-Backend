class PhaseAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :phase
end

# == Schema Information
#
# Table name: phase_attempts
#
#  count      :integer
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  phase_id   :integer
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_phase_attempts_on_phase_id  (phase_id)
#  index_phase_attempts_on_user_id   (user_id)
#
