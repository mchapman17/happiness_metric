class Group < ActiveRecord::Base

  has_secure_password

  has_many :scores, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "already taken" }
  validates :password, length: { minimum: 6 }

end
