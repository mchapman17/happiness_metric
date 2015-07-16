class Group < ActiveRecord::Base

  has_secure_password

  has_many :scores, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "already taken" }
  validates :password, length: { minimum: 6 }

  def average_score
    included_scores.average(:score).to_f.round(2)
  end

  def included_scores
    scores.exclude_after_weeks(exclude_score_after_weeks)
  end

end
