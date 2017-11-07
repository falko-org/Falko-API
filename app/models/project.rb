class Project < ApplicationRecord
  has_many :releases, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :check_project, inclusion: { in: [true, false] }
end
