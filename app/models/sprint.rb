class Sprint < ApplicationRecord

  belongs_to :project, dependent: :destroy
  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }

end
