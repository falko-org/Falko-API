require 'test_helper'
class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(name: 'Ronaldo', email: 'ronaldofenomeno@gmail.com', password: '123456789', password_confirmation: '123456789', github: 'ronaldobola')
  end

  test "should login with rights params" do
    post '/authenticate', params: { email: 'ronaldofenomeno@gmail.com', password: '123456789' }
    assert_response :success
  end

  test "should not login with wrongs params" do
    @post = post '/authenticate', params: { email: 'fenomeno@gmail.com', password: '123456789' }
    assert_response :unauthorized
  end

  test "should create a user with valids params" do
    assert_difference('User.count') do
      post '/users', params: {
        "user":{
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

  test "should not create a user with invalid email" do
    post '/users', params: {
      "user":{
        "email": "robakasdddi",
        "name": "Fulvvano",
        "password": "123456789",
        "password_confirmation": "123456789",
        "github": "fulanao"
      }
    }
    assert_response :unprocessable_entity
  end

  test "should delete user " do
    @token = AuthenticateUser.call(@user.email, @user.password)
    delete "/users/#{@user.id}", headers: {:Authorization => @token.result}
    assert_response :success
  end

  test "should show user" do
    @token = AuthenticateUser.call(@user.email, @user.password)
    get "/users/#{@user.id}", headers: {:Authorization => @token.result}
    assert_response :success
  end

  test "should update user" do
    @token = AuthenticateUser.call(@user.email, @user.password)
    patch "/users/#{@user.id}", params: {
       "user":{
         "email":"robakasdddi@email.com",
         "name":"Fulvvano",
         "password":"123456789",
         "password_confirmation":"123456789",
         "github":"fulanao"
       }
     }, headers: {:Authorization => @token.result}
     @user.reload
    assert_response :success
  end

  test "should authenticate user with github" do

    RestClient.stub :post, "access_token=token123&outra_coisa=outrosvalores" do
      post "/request_github_token", params: {
        "code":"code123",
        "id":"#{@user.id}"
      }

      assert_response :success
      assert response.parsed_body["access_token"] != "bad_verification_code"
    end

  end

  test "should not authenticate with bad verification code" do

    RestClient.stub :post, "access_token=bad_verification_code&outra_coisa=outrosvalores" do
      post "/request_github_token", params: {
        "code":"code123",
        "id":"#{@user.id}"
      }

      assert_response :bad_request
    end

  end

  test "should not authenticate with another id" do

    RestClient.stub :post, "access_token=token123&outra_coisa=outrosvalores" do

      exception = assert_raises ActiveRecord::RecordNotFound do
        post "/request_github_token", params: {
          "code":"code123",
          "id": "2"
        }

        assert_response 500

      end

      assert_equal("Couldn't find User with 'id'=2", exception.message)

    end

  end

  test "should render unprocessable entity" do

    RestClient.stub :post, "access_token=&outra_coisa=outrosvalores" do
      post "/request_github_token", params: {
        "code":"code123",
        "id":"#{@user.id}"
      }

      assert_response :bad_request
    end

  end

end
