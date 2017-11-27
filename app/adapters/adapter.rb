module Adapter

	class GitHubProject

		def initialize(request)
			@logged_user = AuthorizeApiRequest.call(request.headers).result
			@client = Octokit::Client.new(access_token: @logged_user.access_token)
	  end

		def get_github_user
			user_login = @client.user.login
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
	  end

		def get_github_user
			user_login = @client.user.login
		end

		def list_issues(path)
			@client.list_issues(path)
		end

		def create_issue(path, issue_params)
			@client.create_issue(path, issue_params[:name], issue_params[:body])
		end

		def update_issue(path, issue_params)
			@client.update_issue(path, issue_params[:name], issue_params[:body], issue_params[:number])
		end

		def close_issue(path, issue_params)
			@client.close_issue(path, issue_params[:number])
		end

	end

end
