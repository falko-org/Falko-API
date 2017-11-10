class Revision < ApplicationRecord
  belongs_to :sprint

  validates :done_report, presence: true, length: { maximum: 500 }
  validates :undone_report, presence: true, length: { maximum: 500 }
end
