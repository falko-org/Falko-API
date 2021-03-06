module Adapter
  class GitHubProject
    def initialize(request)
      @logged_user = AuthorizeApiRequest.call(request.headers).result
      @client = Octokit::Client.new(access_token: @logged_user.access_token)
      Octokit.auto_paginate = true
      @client
    end

    def get_github_user
      user_login = @client.user.login
      return user_login
    end

    def get_github_repos(user_login)
      @client.repositories(user_login)
      end

    def get_github_orgs(user_login)
      @client.organizations(user_login)
    end

    def get_github_orgs_repos(org)
      @client.organization_repositories(org.login)
    end

    def get_contributors(github_slug)
      @client.contributors(github_slug)
    end
  end

  class GitHubIssue
    def initialize(request)
      @logged_user = AuthorizeApiRequest.call(request.headers).result
      @client = Octokit::Client.new(access_token: @logged_user.access_token)
      @client.auto_paginate = false
      @client
    end

    def get_github_user
      user_login = @client.user.login
    end

    def list_issues(github_slug, page_number)
      @client.list_issues(github_slug, page: page_number, per_page: 15)
    end

    def total_issues_pages(last_page)
      header_response = @client.last_response.rels[:last]
      unless header_response.nil?
        number_of_pages = header_response.href.match(/page=(\d+).*$/)[1]
        return number_of_pages.to_i
      else
        return last_page.to_i
      end
    end

    def list_all_issues(github_slug)
      @client.list_issues(github_slug, state: "all")
    end

    def create_issue(github_slug, issue_params)
      @client.create_issue(github_slug, issue_params[:name], issue_params[:body])
    end

    def update_issue(github_slug, issue_params)
      @client.update_issue(github_slug, issue_params[:number], issue_params[:name], issue_params[:body])
    end

    def close_issue(github_slug, issue_params)
      @client.close_issue(github_slug, issue_params[:number])
    end

    def reopen_issue(github_slug, issue_params)
      @client.reopen_issue(github_slug, issue_params[:number])
    end
  end
end
