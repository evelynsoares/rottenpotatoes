require "application_system_test_case"

class MoviesTest < ApplicationSystemTestCase
  test "visiting the movies page" do
    visit movies_url

    assert_selector "h1", text: "Movies"
  end
end
