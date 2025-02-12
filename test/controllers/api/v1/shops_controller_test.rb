require "test_helper"

class Api::V1::ShopsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = shops(:one)
    @user5 = users(:five)
  end
  # 获取商铺列表 断言：通过验证
  test "index success: should show shops" do
    get api_v1_shops_path, as: :json
    assert_response 200
    json_res = JSON.parse(response.body, symbolize_names: true)
    # dig可以在hash嵌套中检测元素是否存在
    assert_not_nil json_res.dig(:links, :first)
    assert_not_nil json_res.dig(:links, :last)
    assert_not_nil json_res.dig(:links, :prev)
    assert_not_nil json_res.dig(:links, :next)
  end
  # 获取单个商铺
  test "show success: should show shop" do
    get api_v1_shop_path(@shop), as: :json
    json_response = JSON.parse(self.response.body)
    # 验证状态码
    assert_response 200
    # 验证返回数据
    assert_equal @shop.name, json_response['data']['attributes']['name']
  end
  test "create success: should create shop with token" do
    assert_difference('Shop.count', 1) do
      post api_v1_shops_path,
           headers: {
             Authorization: JsonWebToken.encode(user_id: @user5.id)
           },
           params: {
             shop: { name: 'shop_name', products_count: 10, order_count: 10 }
           },
           as: :json
    end
    assert_response 201
  end

  test "create fail: should not create shop without token" do
    post api_v1_shops_path,
         params: {
           shop: { name: 'shop_name', products_count: 10, order_count: 10 }
         },
         as: :json
    assert_response 401
  end

  test "update success: should update shop with owner" do
    put api_v1_shop_path(@shop),
        headers: {
          Authorization: JsonWebToken.encode(user_id: @shop.user.id)
        },
        params: {
          shop: { name: 'shop_name', products_count: 10, order_count: 10 }
        },
        as: :json
    assert_response 201
  end

  test "update fail: should not update shop with other user" do
    put api_v1_shop_path(@shop),
        headers: {
          Authorization: JsonWebToken.encode(user_id: @user5.id)
        },
        params: {
           shop: { name: 'shop_name', products_count: 10, order_count: 10 }
        },
        as: :json
    assert_response 403
  end

  test "destroy success: should destroy shop with owner" do
    assert_difference('Shop.count', -1) do
      delete api_v1_shop_path(@shop),
             headers: {
               Authorization: JsonWebToken.encode(user_id: @shop.user.id)
             },
             as: :json
    end
    assert_response 204
  end

  test "destroy fail: should not delete shop without owner" do
    delete api_v1_shop_path(@shop),
        headers: {
          Authorization: JsonWebToken.encode(user_id: @user5.id)
        },
        as: :json
    assert_response 403
  end
end
