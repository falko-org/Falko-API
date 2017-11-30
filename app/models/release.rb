class Release < ApplicationRecord
  include DateValidationHelper

  belongs_to :project
  has_many :sprints, dependent: :destroy
  has_one :earned_value_management, dependent: :destroy 

  validates :name, presence: true, length: { maximum: 80, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :initial_date, presence: true
  validates :final_date, presence: true

  validate :is_final_date_valid?
end
