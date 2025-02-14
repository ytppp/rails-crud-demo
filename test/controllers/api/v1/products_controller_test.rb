require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @user = users(:two)
  end

  test "index success: should show products" do
    get api_v1_products_path, as: :json
    assert_response 200
    json_res = JSON.parse(response.body, symbolize_names: true)
    # dig可以在hash嵌套中检测元素是否存在
    assert_not_nil json_res.dig(:links, :first)
    assert_not_nil json_res.dig(:links, :last)
    assert_not_nil json_res.dig(:links, :prev)
    assert_not_nil json_res.dig(:links, :next)
  end

  test "show success: should show product" do
    get api_v1_product_path(@product), as: :json
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_response 200
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)
  end

  test "create success: should create product" do
    assert_difference('Product.count', 1) do
      post api_v1_products_path,
           headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
           params: {
             product: {
               title: 'first test', price: 1, published: 1
             }
           },
           as: :json
    end

    assert_response 201
  end

  test "update success: should update product" do
    put api_v1_product_path(@product),
        headers: {
          Authorization: JsonWebToken.encode(user_id: @user.id)
        },
        params: {
          product: {
            title: 'first test', price: 1, published: 1
          }
        },
        as: :json
    assert_response 202
  end

  test "update forbidden: forbidden update product cause unonwer" do
    put api_v1_product_path(@product),
        headers: {
          Authorization: JsonWebToken.encode(user_id: users(:one).id)
        },
        params: {
          product: { title: 'first test', price: 1, published: 1 }
        },
        as: :json
    assert_response 403
  end

  test "destroy success: should destroy product" do
    assert_difference('Product.count', -1) do
      delete api_v1_product_path(@product),
             headers: {
               Authorization: JsonWebToken.encode(user_id: @user.id)
             },
             as: :json
    end
    assert_response 204
  end

  test "destroy forbidden: forbidden destroy product cause unonwer" do
    delete api_v1_product_path(@product),
           headers: {
             Authorization: JsonWebToken.encode(user_id: users(:one).id)
           },
           as: :json
    assert_response 403
  end
end
