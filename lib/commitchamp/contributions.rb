module Commitchamp
	class Contributions
		include HTTParty
		base_uri "https://api.github.com"

		def initialize(token)
			@auth = {
				"Authorization"	=> "token #{token}",
				"User-Agent"		=> "HTTParty"
			}
		end

		def get_contributions(owner, repo)
			self.class.get("/repos/#{owner}/#{repo}/stats/contributors", :header => @auth)
		end

		def get_sums_by_user(contributions)
			each_sum = Hash.new
			sums_by_user = Hash.new

			contributions.each do |user|
				login = user["author"]["login"]
				each_sum["a"] = 0
				each_sum["d"] = 0
				each_sum["c"] = 0

				user["weeks"].each do |row|
					each_sum["a"] += row["a"]
					each_sum["d"] += row["d"]
					each_sum["c"] += row["c"]
				end
				sums_by_user[login] = {}
				sums_by_user[login]["a"] = each_sum["a"]
				sums_by_user[login]["d"] = each_sum["d"]
				sums_by_user[login]["c"] = each_sum["c"]

			end
			sums_by_user
		end

	end
end
