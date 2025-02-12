require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @p_one = products(:one)
  end
  test "valid: product with all valid params" do
    product = Product.new(title: 'title123', price: 1, published: 1, shop_id: @p_one.shop.id)
    assert product.valid?
  end
  test 'invalid: product with invalid title' do
    product = Product.new(title: '', price: 1, published: 1, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end
  test 'invalid: product with taken title and shop_id' do
    product = Product.new(title: @p_one.title, price: 1, published: 1, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end
  test 'invalid: product with invalid published' do
    product = Product.new(title: 'first test', price: 1, published: 2, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end
  test 'invalid: product with invalid price' do
    product = Product.new(title: 'first test', price: -100, published: 1, shop_id: @p_one.shop.id)
    assert_not product.valid?
  end
end
