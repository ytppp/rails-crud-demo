require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
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
end
