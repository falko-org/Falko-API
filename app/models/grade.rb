class Grade < ApplicationRecord
  validates :weight_burndown, presence: true
  validates :weight_velocity, presence: true
  validates :weight_debt, presence: true
end
