require 'test_helper'
class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: 'Ronaldo', email: 'Ronaldofenomeno@gmail.com', password: '123456789', password_confirmation: '123456789', github: 'ronaldobola')
  end

  test "should login in" do
    post '/authenticate', params: {email: 'Ronaldofenomeno@gmail.com', password: '123456789'}
    assert_response :success
  end

   test "should create" do
     assert_difference('User.count') do
       post '/users', params: {
          "user":{
            "email":"robakasdddi@email.com",
            "name":"Fulvvano",
            "password":"123456789",
            "password_confirmation":"123456789",
            "github":"fulanao"
          }
        }
        assert_response :success
     end
  end

  test "should delete" do
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
