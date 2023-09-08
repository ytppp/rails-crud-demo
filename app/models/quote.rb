class Quote < ApplicationRecord
  belongs_to :company
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # after_create_commit ->(quote) { broadcast_prepend_later_to [quote.company, "quotes"] }
  # after_update_commit ->(quote) { broadcast_replace_later_to  [quote.company, "quotes"] }
  # after_destroy_commit ->(quote) { broadcast_remove_to [quote.company, "quotes"] }
  # 上面的可以直接用下面的代替
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend
end