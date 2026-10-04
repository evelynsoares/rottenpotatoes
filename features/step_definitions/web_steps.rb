# Generic, reusable Capybara steps shared by every feature file in this app.
# They don't know anything about "movies" — they only translate common
# Gherkin phrasing ("I fill in", "I press", "I follow"...) into Capybara
# calls, so each feature stays readable without re-implementing the same
# low level interaction for every scenario.

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I select {string} from {string}") do |value, field|
  select value, from: field
end

When("I press {string}") do |button|
  click_button button
end

When("I follow {string}") do |link_text|
  click_link link_text
end

Then("I should see {string}") do |text|
  page.assert_text(text)
end

Then("I should not see {string}") do |text|
  page.assert_no_text(text)
end

# Used by the declarative sorting scenario (and reusable by any future
# scenario that needs to check relative order of two pieces of text).
Then("I should see {string} before {string}") do |first, second|
  regexp = /#{Regexp.escape(first)}.*#{Regexp.escape(second)}/m
  unless page.body =~ regexp
    raise "expected to find \"#{first}\" before \"#{second}\", but didn't"
  end
end
