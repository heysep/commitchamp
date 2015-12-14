# Commitchamp

## Description

A ruby gem I built to aggregate commit statistics from Github while at The Iron Yard Academy.

## Learning Objectives

* Be able to make HTTP requests from Ruby
* Be able to work with the nested JSON responses that most APIs return
* Have some understanding of Authentication through Request Headers

## Performance Objectives

* HTTParty (or similar) for making requests
* Parsed JSON responses

## Usage

Running `bundle exec ruby lib/commit_champ.rb` should:

* Prompt the user for an auth token
* Ask the user what org/repo to get data about from github
* Print a table of contributions ranked in various ways
* Ask the user if they'd like to fetch another or quit.

## Functionality

* Get the list of [contributions][contributors] for the specified repo.
* Figure out how many lines the user added, deleted, and their commit count.

[contributors]: https://developer.github.com/v3/repos/statistics/#contributors

Once all the contributions have been collected for a repo, offer to sort
them by:

1) lines added
2) lines deleted
3) total lines changed
4) commits made

Then print the commit counts in a table as below:

```
## Contributions for 'owner/repo'

Username      Additions     Deletions     Commits
User 1            13534          2954        6249
User 2             6940           913        1603
...
```

Finally, ask the user if they'd like to sort the data differently,
fetch another repo, or quit.

* Allow the user to specify just an organization. 
* Get data for *all* it's repos and aggregate the data to rank the members of the organization.

[members]: https://developer.github.com/v3/orgs/members/#public-members-list

