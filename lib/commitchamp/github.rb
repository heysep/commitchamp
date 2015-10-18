module Commitchamp
	class GitHub
		include HTTParty
		base_uri "https://api.github.com"

		def initialize(token)
			@auth = {
				"Authorization"	=> "token #{token}",
				"User-Agent"	=> "HTTParty"
			}
		end

		def get_contributors(owner, repo)
			self.class.get("/repos/#{owner}/#{repo}/stats/contributors", :headers => @auth)
		end

		def get_repos(org)
			self.class.get("/orgs/#{org}/repos", :headers => @auth)
		end

	end
end