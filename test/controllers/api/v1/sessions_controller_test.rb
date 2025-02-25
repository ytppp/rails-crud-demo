require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end
  test "create success: create token with legal email and password" do
    post api_v1_sessions_path, params:{user:{email:@user.email, password:"123456"}}, as: :json
    assert_response 201
    
    json_response = JSON.parse(response.body)
    assert_not json_response['data']['token'].blank?
  end
  test "create fail: create token with legal email and illegal password" do
    post api_v1_sessions_path, params:{user:{email:@user.email, password:"123"}}, as: :json
    assert_response 401
  end
end
