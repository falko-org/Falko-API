class Feature < ApplicationRecord
  belongs_to :project
  has_many :stories, dependent: :destroy

  validates :title, presence: true, length: { maximum: 80, minimum: 2 }
  validates :description, length: { maximum: 256 }
end
