class ShopSerializer
  include JSONAPI::Serializer
  attributes :name, :products_count, :orders_count
  belongs_to :user
end
