require 'rails_helper'

RSpec.describe PhaseAttempt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
