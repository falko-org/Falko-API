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

end
