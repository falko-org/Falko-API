class IssuesController < ApplicationController
  before_action :set_authorization, :set_path

  def index

    @issues = @client.list_issues(@path)

    @form_params = { issues_names: [] }
    @issues.each do |issue|
      @form_params[:issues_names].push(issue.title)
    end

    render json: @form_params

  end

  def create

    @issue = @client.create_issue(@path, issue_params[:name], issue_params[:body], options = {assignee: issue_params[:assignee], labels: issue_params[:labels]})

    render json: @issue, status: :created

  end

  def update

    @issue = @client.update_issue(@path, issue_params[:number], issue_params[:name], issue_params[:body], options = {assignee: issue_params[:assignee], labels: [issue_params[:labels]]})

    render json: @issue

  end

  def close

    @issue = @client.close_issue(@path, issue_params[:number])

  end

  private

    def set_authorization
      @current_user = AuthorizeApiRequest.call(request.headers).result
      @client = Octokit::Client.new(access_token: @current_user.access_token)
    end

    def set_path

      @project = Project.find(params[:id])

      if @project.name.include? "/"
        @path = @project.name
      else
        @name = @client.user.login
        @repo = @project.name
        @path = @name + "/" + @repo
      end

      @path
    end

    def issue_params
      params.require(:issue).permit(:name, :body, :assignee, :labels, :number)
    end

end
