class Project < ApplicationRecord
  belongs_to :user
  has_many :releases, dependent: :destroy

  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :is_project_from_github, inclusion: { in: [true, false] }
  validates :is_scoring, inclusion: { in: [true, false] }
end
