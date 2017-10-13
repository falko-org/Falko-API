require 'test_helper'

class ReleasesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(name: 'Robert', email: 'robert@email.com',
                        password: '123123', password_confirmation: '123123',
                        github: 'robertGit')
    @project = Project.create(name: "Falko", description: "Description.",
                              user_id: @user.id)
    @release = Release.create(name: "R1", description: "Description",
                        initial_date: "2018-01-01", final_date: "2019-01-01",
                        amount_of_sprints: "20", project_id: @project.id)
    @token = AuthenticateUser.call(@user.email, @user.password)

    @user_another = User.create(name: 'Ronaldo', email: 'ronaldo@email.com',
                        password: '123123', password_confirmation: '123123',
                        github: 'ronaldoGit')
    @project_another = Project.create(name: "Futebol", description: "Description.",
                              user_id: @user.id)
    @release_another = Release.create(name: "Real Madrid", description: "Descriptions",
                        initial_date: "2018-01-01", final_date: "2019-01-01",
                        amount_of_sprints: "20", project_id: @project.id)
    @token_another = AuthenticateUser.call(@user.email, @user.password)

  end

  test "should create release" do
    post "/projects/#{@project.id}/releases", params: {
      "release": {
        "name":"Release 01",
        "description":"First Release",
        "amount_of_sprints":"20",
        "initial_date":"2018-01-01",
        "final_date":"2019-01-01"
      }
    }, headers: {:Authorization => @token.result}

    assert_response :created
  end

  test "should not create release without correct params" do
    post "/projects/#{@project.id}/releases", params: {
      "release": {
        "name":"Release 01",
        "description":"First Release",
        "amount_of_sprints":"20",
        "initial_date":"2018-01-01",
        "final_date":"2017-01-01"
      }
    }, headers: {:Authorization => @token.result}

    assert_response 422
  end


  test "should not create release without authentication" do
    post "/projects/#{@project.id}/releases", params: {
      "release": {
        "name":"Release 01",
        "description":"First Release",
        "amount_of_sprints":"20",
        "initial_date":"2018-01-01",
        "final_date":"2019-01-01"
      }
    }

    assert_response 401
  end


  test "should not get releases index" do
    get "/projects/#{@project.id}/releases"
    assert_response 401
  end

  test "should get releases index" do
    get "/projects/#{@project.id}/releases", headers: {:Authorization => @token.result}
    assert_response :success
  end

  test "should not get releases show" do
    get "/releases/#{@release.id}"
    assert_response 401
  end

  test "should get releases show" do
    get "/releases/#{@release.id}", headers: {:Authorization => @token.result}
    assert_response :success
  end

  test "should edit releases" do
    @old_name_release = @release.name
    @old_description_release = @release.description
    @old_initial_date_release = @release.initial_date

    patch "/releases/#{@release.id}", params:{ release: {name: "Daniboy", description: "CBlacku", initial_date: "2010-05-06"}}, headers: {:Authorization => @token.result}
    @release.reload
    assert_not_equal @old_name_release, @release.name
    assert_not_equal @old_description_release, @release.description
    assert_not_equal @old_initial_date_release, @release.initial_date
  end

  test "should not edit releases without authenticantion" do
    @old_name_release = @release.name
    @old_description_release = @release.description
    @old_initial_date_release = @release.initial_date

    patch "/releases/#{@release.id}", params:{ release: {name: "Daniboy", description: "CBlacku", initial_date: "2010-05-06"}}
    @release.reload
    assert_equal @old_name_release, @release.name
    assert_equal @old_description_release, @release.description
    assert_equal @old_initial_date_release, @release.initial_date
  end

  test "should not edit releases with blank params" do
    @old_name_release = @release.name
    @old_description_release = @release.description
    @old_initial_date_release = @release.initial_date

    patch "/releases/#{@release.id}", params:{ release: {name: "", description: "", initial_date: ""}}, headers: {:Authorization => @token.result}
    @release.reload
    assert_equal @old_name_release, @release.name
    assert_equal @old_description_release, @release.description
    assert_equal @old_initial_date_release, @release.initial_date
  end

  test "should destroy release" do
    assert_difference('Release.count', -1) do
      delete "/releases/#{@release.id}", headers: {:Authorization => @token.result}
    end
    assert_response 204
  end

  test "should not destroy release without authentication" do
    assert_no_difference 'Release.count' do
        delete "/releases/#{@release.id}"
    end
  end

# FIX ME
  # test "should not destroy release with another user" do
  #   assert_no_difference 'Release.count' do
  #       delete "/releases/#{@release.id}", headers: {:Authorization => @token_another.result}
  #   end
  # end
  
end
