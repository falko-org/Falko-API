require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(
      name: "Ronaldo",
      email: "ronaldofenomeno@gmail.com",
      password: "123456789",
      password_confirmation: "123456789",
      github: "ronaldobola"
    )

    @token = AuthenticateUser.call(@user.email, @user.password)
  end

  test "should login in" do
    post "/authenticate", params: { email: "ronaldofenomeno@gmail.com", password: "123456789" }

    assert_response :success
  end

  test "should create valid user" do
   assert_difference("User.count") do
      post "/users", params: {
        "user": {
          "email": "robakasdddi@email.com",
          "name": "Fulvvano",
          "password": "123456789",
          "password_confirmation": "123456789",
          "github": "fulanao"
        }
      }, headers: { Authorization: @token.result }

      assert_response :success
    end
 end

  test "should login with rights params" do
    post "/authenticate", params: { email: "ronaldofenomeno@gmail.com", password: "123456789" }

    assert_response :success
  end

  test "should not login with wrongs params" do
    post "/authenticate", params: { email: "fenomeno@gmail.com", password: "123456789" }

    assert_response :unauthorized
  end

  test "should create a user with valids params" do
    assert_difference("User.count") do
      post "/users", params: {
        "user": {
          "email": "robakasdddi@email.com",
          "name": "Fulvvano",
          "password": "123456789",
          "password_confirmation": "123456789",
          "github": "fulanao"
        }
      }

      assert_response :success
    end
  end

  test "should not create invalid user with short name" do
    assert_no_difference("User.count") do
      post "/users", params: {
        "user": {
          "email": "robakasdddi@email.com",
          "name": "Fu",
          "password": "123456789",
          "password_confirmation": "123456789",
          "github": "fulanao"
        }
      }

      assert_response :unprocessable_entity
    end
  end

  test "should not create invalid user with too large name" do
    assert_no_difference("User.count") do
      post "/users", params: {
        "user": {
          "email": "robakasdddi@email.com",
          "name": "F" * 81,
          "password": "123456789",
          "password_confirmation": "123456789",
          "github": "fulanao"
        }
      }

      assert_response :unprocessable_entity
    end
  end


  test "should delete user" do
    delete "/users/#{@user.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should show user" do
    get "/users/#{@user.id}", headers: { Authorization: @token.result }

    assert_response :success
  end

  test "should update user" do
    patch "/users/#{@user.id}", params: {
      "user": {
        "name": "Fulvvano123",
        "github": "fulanao123"
      }
    }, headers: { Authorization: @token.result }

    @user.reload

    assert_response :success
  end

  test "should not update user without authentication" do
    patch "/users/#{@user.id}", params: {
      "user": {
        "email": "robakasdddi@email.com",
        "name": "Fulvvano",
        "github": "fulanao"
      }
    }
    @user.reload

    assert_response :unauthorized
  end

  test "should not update user with invalid params" do
    patch "/users/#{@user.id}", params: {
      "user": {
        "email": "robakasdddi@email.com",
        "name": "Fulvvano",
        "password": "12345",
        "password_confirmation": "123456789",
        "github": "fulanao"
       }
     }, headers: { Authorization: @token.result }
    @user.reload

    assert_response :unprocessable_entity
    assert response.parsed_body["access_token"] != "bad_verification_code"
  end

  test "should authenticate user with github" do
    RestClient.stub :post, "access_token=token123&outra_coisa=outrosvalores" do
      post "/request_github_token", params: {
        "code": "code123",
        "id": "#{@user.id}"
      }, headers: { Authorization: @token.result }

      assert_response :success
      assert response.parsed_body["access_token"] != "bad_verification_code"
    end
  end

  test "should not authenticate with bad verification code" do
    RestClient.stub :post, "access_token=bad_verification_code&outra_coisa=outrosvalores" do
      post "/request_github_token", params: {
        "code": "code123",
        "id": "#{@user.id}"
      }, headers: { Authorization: @token.result }

      assert_response :bad_request
    end
  end

  test "should not authenticate with another id" do
    RestClient.stub :post, "access_token=token123&outra_coisa=outrosvalores" do

      exception = assert_raises ActiveRecord::RecordNotFound do
        post "/request_github_token", params: {
          "code": "code123",
          "id": "2"
        }, headers: { Authorization: @token.result }

        assert_response 500
      end
      assert_equal("Couldn't find User with 'id'=2", exception.message)
    end
  end

  test "should render unprocessable entity" do
    RestClient.stub :post, "access_token=&outra_coisa=outrosvalores" do
      post "/request_github_token", params: {
        "code": "code123",
        "id": "#{@user.id}"
      }, headers: { Authorization: @token.result }

      assert_response :bad_request
    end
  end
end
