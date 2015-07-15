class Score < ActiveRecord::Base

  belongs_to :group

  scope :exclude_after_weeks, ->(num = 0) { where("scores.updated_at >= ?", num.weeks.ago) unless num.zero? }

end
