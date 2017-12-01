class Story < ApplicationRecord
  include DateValidationHelper

  belongs_to :sprint
  belongs_to :feature

  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :assign, length: { maximum: 32, minimum: 2 }, allow_blank: true
  validates :pipeline, length: { maximum: 16, minimum: 4 }
  validates :initial_date, presence: true
  validates :issue_number, presence: true
  validates :is_closed, inclusion: { in: [true, false] }
  validate :is_final_date_valid?
  validates :feature_id, presence: true
end
