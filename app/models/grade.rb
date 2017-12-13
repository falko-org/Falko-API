class Grade < ApplicationRecord
  belongs_to :project

  validates :weight_burndown, presence: true
  validates :weight_velocity, presence: true
  validates :weight_debts, presence: true
end
