require "test_helper"

class ShopTest < ActiveSupport::TestCase
  # 使用全部合法的参数 断言：通过验证
  test "valid: shop with all valid things" do
    shop = Shop.new(name: 'shoptest01', products_count: 0, orders_count: 1)
    shop.user = users(:four)
    assert shop.valid?
  end

  # 使用 重复的name，合法的user_id，合法的products_count， 合法的orders_count创建商铺，断言：未通过验证
  test "invalid: shop with token name" do
    shop = Shop.new(name: shops(:one).name, products_count: 0, orders_count: 1)
    shop.user = users(:four)
    assert_not shop.valid?
  end

  # 使用 非法的user_id，合法的name， 合法的products_count， 合法的orders_count创建商铺，断言：未通过验证
  test "invalid: shop with invalid user_id" do
    shop = Shop.new(name: 'shoptest02', products_count: 0, orders_count: 1)
    shop.user = users(:one)
    assert_not shop.valid?
  end

  # 使用 重复的user_id，合法的name， 合法的products_count， 合法的orders_count创建商铺，断言：未通过验证
  test "invalid: shop with token user_id" do
    shop = Shop.new(name: 'shoptest03', products_count: 0, orders_count: 1)
    shop.user = shops(:one).user
    assert_not shop.valid?
  end

  # 使用 非法的products_count，合法的name， 合法的user_id， 合法的orders_count创建商铺，断言：未通过验证
  test "invalid: shop with invalid products_count" do
    shop = Shop.new(name: 'shoptest04', products_count: 1.55, orders_count: 1)
    shop.user = users(:five)
    assert_not shop.valid?
  end
end
