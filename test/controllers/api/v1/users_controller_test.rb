require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user2 = users(:two)
  end
  test "index_success: show users" do
    get api_v1_users_path,
      headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
      as: :json
    assert_response 200
    json_res = JSON.parse(response.body, symbolize_names: true)
    # dig可以在hash嵌套中检测元素是否存在
    assert_not_nil json_res.dig(:links, :first)
    assert_not_nil json_res.dig(:links, :last)
    assert_not_nil json_res.dig(:links, :prev)
    assert_not_nil json_res.dig(:links, :next)

  end
  test "index_forbidden: forbiden show users not admin privileges" do
    get api_v1_users_path,
      headers: { Authorization: JsonWebToken.encode(user_id: @user2.id) },
      as: :json
    assert_response 403
  end
  test "show_success: should show user" do
    get api_v1_user_path(@user), as: :json
    json_response = JSON.parse(self.response.body)
    # 验证状态码
    assert_response 200
    # 验证返回数据
    assert_equal @user.email, json_response['data']['attributes']['email']
  end
  test "create_success: should create user" do
    assert_difference('User.count', 1) do
      post api_v1_users_path, params: {user:{email: 'test@test.com', password: '123456'}}, as: :json
    end
    assert_response 201
  end
  test "update_success: should update user" do
    put api_v1_user_path(@user),
      params: {user:{email: 'test@test.com', password: '123456'}},
      headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
      as: :json
    assert_response 202
  end
  test "update_forbidden: should forbiden update user not admin privileges" do
    put api_v1_user_path(@user),
      params: {user:{email: 'test1@test.com', password: '123456'}},
      headers: { Authorization: JsonWebToken.encode(user_id: @user2.id) },
      as: :json

    assert_response 403
  end
  test "destroy_success: should destroy user" do
    # 验证某个值变化了
    assert_difference('User.count', -1) do
      delete api_v1_user_path(@user),
        headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
        as: :json
    end
    assert_response 204
  end
  test "destroy_forbidden: should forbiden destroy user not admin privileges" do
    delete api_v1_user_path(@user),
    headers: { Authorization: JsonWebToken.encode(user_id: @user2.id) },
    as: :json

    assert_response 403
  end
end
