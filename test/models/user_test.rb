require 'test_helper'

class UserTest < ActiveSupport::TestCase

    def setup
      @user = User.create(name: "Gilberto", email: "gilbertin@teste.com", password: "1234567", github: "gilbertoCoder")
    end

    test "should save a valid user" do
      assert @user.save
    end

    test "User should have a name" do
      @user.name = ""
      assert_not @user.save
    end

    test "User name should have more than 5 characters" do
      @user.name = "gil"
      assert_not @user.save
    end

    test "User name should not have more than 80 characters" do
      @user.name = "a" * 81
      assert_not @user.save
    end

    test "The number of characters in user name is between 5 and 80" do
      @user.name = "odada"
      assert @user.save
      @user.name = "a" * 80
      assert @user.save
    end

    test "User should have a email" do
      @user.email = ""
      assert_not @user.save
    end

    test "should note save user with duplicate emails" do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email
      @user.save
      assert_not duplicate_user.save
    end

    test "should save email with right validation format" do
      valid_addresses = %w[testing@example.com user@foo.COM A_MEM-BER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.save, "#{valid_address.inspect} should be valid"
    end
    end

    test "should not save user with email in an invalid format" do
      invalid_addresses = %w[testing@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.save, "#{invalid_address.inspect} should be invalid"
    end
    end

    test "User should not have a blank password" do
      @user.password = ""
      assert_not @user.save
    end

    test "User password should not have less than 6 characters" do
      @user.password = "gil"
      assert_not @user.save
    end

    test "User password should not have more than 80 characters" do
      @user.name = "a" * 81
      assert_not @user.save
    end

    test "The number of characters in user password is between 6 and 80" do
      @user.password = "odadad"
      assert @user.save
      @user.password = "a" * 80
      assert @user.save
    end

    test "User should have a github" do
      @user.github = ""
      assert_not @user.save
    end

end
