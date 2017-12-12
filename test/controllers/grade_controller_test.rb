require 'test_helper'

class GradeControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get grade_update_url
    assert_response :success
  end

  test "should get create" do
    get grade_create_url
    assert_response :success
  end

  test "should get show" do
    get grade_show_url
    assert_response :success
  end

end
