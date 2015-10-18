require "httparty"
require "pry"

require "commitchamp/version"
require "commitchamp/github"
# Probably you also want to add a class for talking to github.

module Commitchamp
  	class App
  		attr_reader :github

    	def initialize
	    	puts "My fe-rend, vaaht eez yor toeke-en?"
	    	token = gets.chomp
	    	@github = GitHub.new(token)
    	end

	    def run
	    	owner = prompt_user("Enter the org name:")
	    	repos = prompt_user("Enter the repo name (leave blank for all repos):")
			repos = repos == "" ? build_repos(owner) : [repos]

	    	data = build_data(owner, repos)
	    	data = sort_data(data)
	    	show_data(data)

	    	action = what_to_do
	    	until action == "quit"
	    		if action == "sort"
	    			data = sort(data)
	    			show_data(data)
	    		else 
	    			run
	    		end
	    		action = what_to_do
	    	end
	    	puts "Good bye."
    	end

    	private
    	def what_to_do
    		puts "Do you want to \"sort\", \"fetch\", or \"quit\"?"
    		action = gets.chomp
    		until ["sort", "fetch", "quit"].include?(action)
    			puts "Type sort, fetch or quit:"
    			action = gets.chomp
    		end
    		action
    	end

    	def prompt_user(text)
	    	puts text
	    	gets.chomp 
	    end

	    def build_repos(owner)
	    	repos = @github.get_repos(owner)
	    	names = []
	    	repos.each do |repo|
	    		names.push(repo["name"]) if repo["size"] != 0
	    	end
	    	names
	    end

	    def build_data(owner, repos)
			each_sum = Hash.new
			sums_by_user = Hash.new

	    	repos.each do |repo|
	    		contributors = @github.get_contributors(owner, repo)
				contributors.each do |user|

					login = user["author"]["login"].to_sym
					each_sum[:additions] = 0
					each_sum[:deletions] = 0
					each_sum[:changes] = 0
					each_sum[:commits] = 0

					user["weeks"].each do |week|
						each_sum[:additions] += week["a"]
						each_sum[:deletions] += week["d"]
						each_sum[:changes]   += week["a"] + week["d"]
						each_sum[:commits]   += week["c"]
					end
					sums_by_user[login] = {}
					sums_by_user[login][:additions]	= each_sum[:additions]
					sums_by_user[login][:deletions]	= each_sum[:deletions]
					sums_by_user[login][:changes]	= each_sum[:changes]
					sums_by_user[login][:commits]	= each_sum[:commits]
				end
			end
			sums_by_user
		end

    	def sort_data(data)
			puts "What do want to sort by? Type additions, deletions, changes, commits:"
			order_by = gets.chomp
			until ["additions", "deletions", "changes", "commits"].include?(order_by)
				puts "Type additions, deletions, changes, commits:"
				order_by = gets.chomp
			end
			puts "Sort asc or desc?"
			sort = gets.chomp
			until ["asc", "desc"].include?(sort)
				puts "Type asc or desc:"
				sort = gets.chomp
			end
			if sort == "desc"
				data = data.sort_by { |k, v| v[order_by.to_sym]}.reverse
			else
				data = data.sort_by { |k, v| v[order_by.to_sym]}
			end
			data
		end

    	def show_data(data)
	    	printf("%-18s %-10s %-10s %-10s %-10s\n","Username", "Additions", "Deletions", "Changes", "Commits")
	    	puts "==========================================================="
	    	data.each do |row|
	    		printf("%-18s %-10d %-10d %-10d %-10d\n", row[0], row[1][:additions], row[1][:deletions], row[1][:changes], row[1][:commits])
	    	end
	    	puts "==========================================================="
    	end

  	end
end

app = Commitchamp::App.new
binding.pry
#app.run
