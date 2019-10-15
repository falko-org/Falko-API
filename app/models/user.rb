class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :name, presence: true, length: { in: 3..80 }, uniqueness: true
  validates :email, confirmation: true, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_presence_of :password_digest

  has_secure_password

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private


    def generate_token
      SecureRandom.hex(10)
    end
end
