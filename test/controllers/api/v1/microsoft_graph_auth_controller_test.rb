require "test_helper"

class Api::V1::MicrosoftGraphAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get authorize" do
    get api_v1_microsoft_graph_auth_authorize_url
    assert_response :success
  end

  test "should get callback" do
    get api_v1_microsoft_graph_auth_callback_url
    assert_response :success
  end
end
