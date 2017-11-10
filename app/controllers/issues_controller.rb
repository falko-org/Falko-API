require "rest-client"

class IssuesController < ApplicationController
  before_action :set_authorization, except: [:update_assignees]
  before_action :set_path, except: [:update_assignees]

  def index
    @issues = @client.list_issues(@path)

    convert_form_params(@issues)

    render json: @form_params
  end

  def create
    @issue = @client.create_issue(@path, issue_params[:name], issue_params[:body], options = { assignee: issue_params[:assignee], labels: issue_params[:labels] })

    convert_form_params(@issue)

    render json: @form_params, status: :created
  end

  def update
    @issue = @client.update_issue(@path, issue_params[:number], issue_params[:name], issue_params[:body], options = { assignee: issue_params[:assignee], labels: [issue_params[:labels]] })

    convert_form_params(@issue)

    render json: @form_params
  end

  def close
    @issue = @client.close_issue(@path, issue_params[:number])

    render status: 200
  end

  def update_assignees
    begin
      set_project

      @current_user = AuthorizeApiRequest.call(request.headers).result

      response = RestClient.patch("https://api.github.com/repos/#{@project.github_slug}/issues/#{params[:issue_number]}",
        { assignees: params[:assignees] }.to_json,
        Authorization: "token #{@current_user.access_token}"
      )

      render status: :ok
    rescue RestClient::UnprocessableEntity
      render json: { errors: "Cannot update assignees" }, status: :unprocessable_entity
    rescue RestClient::NotFound
      render json: { errors: "Content not found" }, status: :not_found
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Project not found" }, status: :not_found
    end
  end

  private

    def set_authorization
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @client = Octokit::Client.new(access_token: @current_user.access_token)
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def set_path
      set_project

      if @project.name.include? "/"
        @path = @project.name
      else
        @name = @client.user.login
        @repo = @project.name
        @path = @name + "/" + @repo
      end

      @path
    end

    def convert_form_params(issue)
      @form_params = { issues_infos: [] }
      if issue.kind_of?(Array)
        @issues.each do |issue|
          @form_params[:issues_infos].push(name: issue.title, number: issue.number, body: issue.body)
        end
      else
        @form_params[:issues_infos].push(name: issue.title, number: issue.number, body: issue.body)
      end
      @form_params
    end

    def issue_params
      params.require(:issue).permit(:name, :body, :assignee, :labels, :number)
    end
end
