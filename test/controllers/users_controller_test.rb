require 'test_helper'
class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: 'daniel', email: 'daniel@gmail.com', password: '123456789', password_confirmation: '123456789', github: 'danieloda')
  end

  test "should create user" do
    post '/users', @user
  end















end
