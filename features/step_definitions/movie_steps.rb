# Step definitions specific to the RottenPotatoes "movies" domain: they
# know about app routes/pages (home page, create-movie page) and about
# the Movie model (used directly by the declarative step below).

Given("I am on the RottenPotatoes home page") do
  visit root_path
end

# In this app both "/" (root) and "/movies" render the same movie list,
# so either one counts as "the RottenPotatoes home page".
Then("I should be on the RottenPotatoes home page") do
  unless [ root_path, movies_path ].include?(current_path)
    raise "expected to be on the RottenPotatoes home page, but was on #{current_path}"
  end
end

Then("I should be on the Create New Movie page") do
  unless current_path == new_movie_path
    raise "expected to be on the Create New Movie page, but was on #{current_path}"
  end
end

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
      release_date: movie_attributes["release_date"]
    )
  end
end

When("I view the movie list sorted by title") do
  visit movies_path(sort_by: "title")
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
