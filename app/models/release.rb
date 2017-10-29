class Release < ApplicationRecord
  include ValidateDateHelper

  has_many :sprints, dependent: :destroy
  belongs_to :project

  validates :name, presence: true, length: { in: 2..80 }
  validates :description, length: { maximum: 256 }
  validates :initial_date, presence: true
  validates :final_date, presence: true

  validate :is_final_date_valid?
end
