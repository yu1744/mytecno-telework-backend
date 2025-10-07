require "test_helper"

class Api::V1::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_applications_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_applications_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_applications_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_applications_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_applications_destroy_url
    assert_response :success
  end
end
