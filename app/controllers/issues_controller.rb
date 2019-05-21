require "rest-client"

class IssuesController < ApplicationController
  include IssueGraphicHelper

  before_action :set_authorization, except: [:update_assignees]
  before_action :set_project

  def index
    client = Adapter::GitHubIssue.new(request)

    @issues = client.list_issues(@project.github_slug, params[:page])

    total_pages = client.total_issues_pages(params[:page])

    convert_form_params(@issues)

    all_stories = Story.all

    all_stories_number = []

    all_stories.each do |story|
      all_stories_number.push(story.issue_number.to_i)
    end

    @filter_form = { issues_infos: [], total_pages: total_pages }

    @filter_form[:issues_infos] = @form_params[:issues_infos].reject do |h|
      all_stories_number.include? h[:issue_id]
    end

    render json: @filter_form
  end

  def create
    client = Adapter::GitHubIssue.new(request)

    @issue = client.create_issue(@project.github_slug, issue_params)

    convert_form_params(@issue)

    render json: @form_params, status: :created
  end

  def update
    client = Adapter::GitHubIssue.new(request)

    @issue = client.update_issue(@project.github_slug, issue_params)

    convert_form_params(@issue)

    render json: @form_params
  end

  def close
    client = Adapter::GitHubIssue.new(request)

    client.close_issue(@project.github_slug, issue_params)

    render status: :ok
  end

  def issue_graphic_data
    client = Adapter::GitHubIssue.new(request)

    @issues = client.list_all_issues(@project.github_slug)

    if @issues.count != 0

      actual_date = params[:actual_date].to_date
      option = params[:option]

      data_of_issues = {}

      data_of_issues = get_issues_graphic(actual_date, option, @issues)

      render json: data_of_issues
    else
      render json: { error: "Issues don't exists" }, status: :not_found
    end
  end

  def reopen_issue
    client = Adapter::GitHubIssue.new(request)

    client.reopen_issue(@project.github_slug, issue_params)

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
      client = Adapter::GitHubIssue.new(request)
    end

    def set_project
      begin
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: "Project not found" }, status: :not_found
      end
    end

    def convert_form_params(issue)
      @form_params = { issues_infos: [] }
      if issue.kind_of?(Array)
        @issues.each do |issue|
          make_form_params(issue)
        end
      else
        make_form_params(issue)
      end
      @form_params
    end

    def assignee_counter(issue)
      assignees = []
      if issue.assignees.count > 0
        issue.assignees.each do |assignee|
          assignees.push(assignee.login)
        end
      end
      assignees
    end

    def make_form_params(issue)
      assignees = assignee_counter(issue)
      @form_params[:issues_infos].push(name: issue.title, number: issue.number, body: issue.body, issue_id: issue.id, assignees: assignees) unless issue.pull_request
    end

    def issue_params
      params.require(:issue).permit(:name, :body, :number)
    end
end
