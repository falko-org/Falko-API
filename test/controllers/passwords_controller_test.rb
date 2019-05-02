require "test_helper"
require "bcrypt"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      "name": "Eduardo",
      "email": "eduardo@gmail.com",
      "password": "asecurepassword",
      "password_confirmation": "asecurepassword"
    )
  end

  test "should create token on forgot password request" do
    post "/password/forgot/", params: {
      "email": "eduardo@gmail.com"
    }
    assert_response :ok
  end

  test "should not create token given a non-existe email" do
    post "/password/forgot/", params: {
      "email": "nonexistent@gmail.com"
    }
    assert_response :ok
  end

  test "should not create token given a blank email" do
    post "/password/forgot/", params: {
      "email": ""
    }
    assert_response :bad_request
  end

  test "should update password given a valid token" do
    post "/password/forgot", params: {
      "email": "eduardo@gmail.com"
    }

    token = User.find_by(id: @user.id).reset_password_token

    post "/password/reset/", params: {
      "token": token,
      "password": "anewsecurepassword",
      "password_confirmation": "anewsecurepassword"
    }
    assert_response :ok

    updated_user = User.find_by(id: @user.id)
    new_password = BCrypt::Password.new(updated_user.password_digest)
    assert(new_password == "anewsecurepassword")
    assert_nil(updated_user.reset_password_token)
  end

  test "should not update password given an expired token" do
    post "/password/forgot/", params: {
      "email": "eduardo@gmail.com"
    }
    travel 5.hour
    token = User.find_by(id: @user.id).reset_password_token
    post "/password/reset/", params: {
      "token": token,
      "password": "anewsecurepassword",
      "password_confirmiation": "anewsecurepassword"
    }
    assert_response :not_found

  end

  test "should not update password given a different token" do
    post "/password/forgot/", params: {
      "email": "eduardo@gmail.com"
    }
    assert_response :ok

    post "/password/reset/", params: {
      "token": SecureRandom.hex(10),
      "password": "somepassword",
      "password_confirmation": "somepasswowrd"
    }
    assert_response :not_found
  end

  test "should not update password given a blank token" do
    post "/password/reset/", params: {
     "token": "",
     "password": "somepassword",
     "password_confirmation": "somepassword"
    }
    assert_response :bad_request
  end
end
