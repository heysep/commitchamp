require "httparty"
require "pry"

require "commitchamp/version"
require "commitchamp/contributions"
# Probably you also want to add a class for talking to github.

module Commitchamp
  	class App
  		attr_reader :contributions

    	def initialize
	    	puts "My fe-rend, vaaht eez yor toeke-en?"
	    	token = gets.chomp
	    	@contributions = Contributions.new(token)
    	end

	    def run
	    	owner = get_input("owner")
	    	repo = get_input("repo")
    	  	contributions = @contributions.get_contributions(owner, repo)
	    	data = @contributions.get_sums_by_user(contributions)
	    	data = sort(data)

	    	print_sums(data)

	    	action = what_to_do
	    	until action == "quit"
	    		if action == "sort"
	    			data = sort(data)
	    			print_sums(data)
	    		else 
	    			run
	    		end
	    		action = what_to_do
	    	end
	    	puts "Good bye."
    	end

    	def what_to_do
    		puts "Do you want to \"sort\", \"fetch\", or \"quit\"?"
    		action = gets.chomp
    		until ["sort", "fetch", "quit"].include?(action)
    			puts "Type sort, fetch or quit:"
    			action = gets.chomp
    		end
    		action
    	end


    	def get_input(label)
	    	puts "What is the #{label}?"
	    	gets.chomp 
	    end

    	def sort(data)
			puts "What do want to sort by? Type a, d, or c:"
			order_by = gets.chomp
			until ["a", "d", "c"].include?(order_by)
				puts "Type a, d, or c:"
				order_by = gets.chomp
			end
			puts "Sort asc or desc?"
			sort = gets.chomp
			until ["asc", "desc"].include?(sort)
				puts "Type asc or desc:"
				sort = gets.chomp
			end
			if sort == "desc"
				data = data.sort_by { |k, v| v[order_by]}.reverse
			else
				data = data.sort_by { |k, v| v[order_by]}
			end
			data
		end

    	def print_sums(data)
	    	printf("%-18s %-10s %-10s %-10s\n","Username", "Additions", "Deletions", "Commits")
	    	puts "================================================="
	    	data.each do |row|
	    		printf("%-18s %-10d %-10d %-10d\n", row[0], row[1]["a"], row[1]["d"], row[1]["c"])
#	    		puts "#{row[0]}:".ljust(20) + "#{row[1]["a"]}".ljust(row[0].length) + "#{row[1]["d"]}".ljust(10) + "#{row[1]["c"]}".ljust(10) 
	    	end
	    	puts "================================================="
    	end

  	end
end

app = Commitchamp::App.new
binding.pry
#app.run
