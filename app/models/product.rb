class Product < ApplicationRecord
  belongs_to :shop

  validates :title, presence: true
  validates :price, presence: true, numericality: { only_float: true, greater_than_or_equal_to: 0 }
  validates :published, inclusion: { in: [1, 0], message: "published can be only in [0 1]" }
  validate :title_cannot_be_taken_in_self_shop

  private
    def title_cannot_be_taken_in_self_shop
      if self.class.exists?(title: title, shop_id: shop_id)
        errors.add(:title, "title can't be taken in self-shop")
      end
    end
end
