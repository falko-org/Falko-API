class Epic < ApplicationRecord
  belongs_to :project
  has_many :features, dependent: :destroy

  validates :title, presence: true, length: { maximum: 80, minimum: 2 }
  validates :description, length: { maximum: 256 }
end
