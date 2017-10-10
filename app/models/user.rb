class User < ApplicationRecord

  has_many :projects
  validates :name, presence: true, length:{in: 5..80}
  validates :email, confirmation: true, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, length:{in: 6..80}, presence: true
  validates :github, presence: true

  has_secure_password

end
