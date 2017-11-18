module Adapter

	class GitHubProject

		def initialize(request)
			@logged_user = AuthorizeApiRequest.call(request.headers).result
			@client = Octokit::Client.new(access_token: @logged_user.access_token)
			@user_login = @client.user.login
	  end

    def get_github_repos
    	@client.repositories(@user_login)
		end

    def get_github_orgs
  	 	@client.organizations(@user_login)
    end

		def get_github_orgs_repos
    	@client.organization_repositories(org.login)
		end

	end

end
