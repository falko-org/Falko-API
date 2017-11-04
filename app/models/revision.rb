class Revision < ApplicationRecord
  validates: :done_report, length: { maximum: 500 }
  validates: :undone_report, length: { maximum: 500 }
end
