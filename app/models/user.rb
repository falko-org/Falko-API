class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :name, presence: true, length: { in: 3..80 }
  validates :email, confirmation: true, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_presence_of :password_digest

  has_secure_password
end
