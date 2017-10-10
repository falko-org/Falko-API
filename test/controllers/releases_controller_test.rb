require 'test_helper'

class ReleasesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get releases_index_url
    assert_response :success
  end

  test "should get new" do
    get releases_new_url
    assert_response :success
  end

  test "should get show" do
    get releases_show_url
    assert_response :success
  end

  test "should get edit" do
    get releases_edit_url
    assert_response :success
  end

  test "should get create" do
    get releases_create_url
    assert_response :success
  end

  test "should get update" do
    get releases_update_url
    assert_response :success
  end

  test "should get destroy" do
    get releases_destroy_url
    assert_response :success
  end

end
