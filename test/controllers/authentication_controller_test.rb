require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should authenticate user" do
    @user = User.create! name: "teste user",
                         email: "test-user@mail.com",
                         email_confirmation: "test-user@mail.com",
                         password: "test-user",
                         github: "userGit"

    post :authenticate, params: { email: "test-user@mail.com", password: "test-user" }
    assert_response :success
  end
end
