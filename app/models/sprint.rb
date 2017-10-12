class Sprint < ApplicationRecord
  include DateValidationHelper

  has_many :stories, dependent: :destroy
  belongs_to :release

  belongs_to :project, dependent: :destroy
  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :initial_date, presence: true
  validates :final_date, presence: true

  validate :is_final_date_valid?
end
