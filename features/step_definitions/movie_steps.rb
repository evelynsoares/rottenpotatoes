# Step definitions specific to the RottenPotatoes "movies" domain: they
# know about the Movie model (used directly by the declarative steps
# below). Navigation steps ("I am on the ... page") live in web_steps.rb
# and features/support/paths.rb.

# --- Declarative step ------------------------------------------------
# Instead of spelling out "visit new movie page, fill in title, select
# rating, fill in release date, press Create Movie" for every movie we
# need in the Background/Given of a scenario, we create the records
# directly through ActiveRecord. The scenario doesn't care *how* the
# movies got there, only that they *exist* -- that's the essence of a
# declarative Given step.
Given("the following movies exist:") do |movies_table|
  movies_table.hashes.each do |movie_attributes|
    Movie.create!(
      title: movie_attributes["title"],
      rating: movie_attributes["rating"],
      release_date: movie_attributes["release_date"],
      # optional column (HW4); an empty cell means "no director info"
      director: movie_attributes["director"].presence
    )
  end
end

# --- Director info (HW4) ---------------------------------------------
# Checks the saved record, not the page: the scenario is about the
# director being stored, wherever it is displayed afterwards.
Then("the director of {string} should be {string}") do |title, director|
  actual = Movie.find_by!(title: title).director
  unless actual == director
    raise "expected the director of \"#{title}\" to be \"#{director}\", but was #{actual.inspect}"
  end
end


# --- Filtering by MPAA rating (HW3, part 2) --------------------------
# One step instead of "When I check 'PG'", "And I check 'R'"...: matches
# both "I check the following ratings: PG, R" and "I uncheck the following
# ratings: G, PG-13". It only touches the listed boxes, leaving the others
# as they were, and reuses the generic check/uncheck steps in web_steps.rb.
When(/^I (un)?check the following ratings: (.*)$/) do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    step %(I #{uncheck}check "ratings_#{rating}")
  end
end

When("I check all ratings") do
  step "I check the following ratings: #{Movie::RATINGS.join(', ')}"
end

# Naming every movie with "I should see" would hide the intent of the
# scenario, so we count the rows of the movie table instead and compare
# with the number of movies in the database.
Then("I should see all of the movies") do
  page.assert_selector("table#movies tbody tr", count: Movie.count)
end

When("I view the movie list sorted by title") do
  visit movies_path(sort_by: "title")
end
