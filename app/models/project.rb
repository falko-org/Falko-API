class Project < ApplicationRecord

  belongs_to :user
  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }

end
