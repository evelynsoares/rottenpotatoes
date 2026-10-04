Feature: Movies, when added, should appear in the movie list sorted by title

  As a movie fan
  So that I can quickly find the movie I am looking for
  I want the movie list to be sortable by title

  # ---------------------------------------------------------------------
  # IMPERATIVE version: spells out every low-level UI interaction needed
  # to put the app in the desired state (fill form, select, press button,
  # follow link...) before finally checking the real behavior under test
  # (the sort order). It is verbose and NOT DRY: if the "add a movie" flow
  # ever changes, every imperative scenario that adds a movie must change.
  # ---------------------------------------------------------------------
  Scenario: View movie list after adding 2 movies (Imperative)
    Given I am on the RottenPotatoes home page
    When I follow "New movie"
    Then I should be on the Create New Movie page
    When I fill in "Title" with "Zorro"
    And I select "PG" from "Rating"
    And I fill in "Release date" with "2020-05-01"
    And I press "Create Movie"
    Then I should see "Movie was successfully created."
    When I follow "Back to movies"
    Then I should be on the RottenPotatoes home page

    When I follow "New movie"
    Then I should be on the Create New Movie page
    When I fill in "Title" with "Apocalypse Now"
    And I select "R" from "Rating"
    And I fill in "Release date" with "1979-08-15"
    And I press "Create Movie"
    Then I should see "Movie was successfully created."
    When I follow "Back to movies"
    Then I should be on the RottenPotatoes home page

    When I follow "Title"
    Then I should see "Apocalypse Now" before "Zorro"

  # ---------------------------------------------------------------------
  # DECLARATIVE version: describes WHAT state the app should be in
  # ("the following movies exist"), not HOW to get there. It hides the
  # UI mechanics of adding a movie behind a single, reusable step and
  # keeps the scenario focused on the behavior being tested: sorting.
  # ---------------------------------------------------------------------
  Scenario: View movie list after adding 2 movies (Declarative)
    Given the following movies exist:
      | title          | rating | release_date |
      | Zorro          | PG     | 2020-05-01   |
      | Apocalypse Now | R      | 1979-08-15   |
    When I view the movie list sorted by title
    Then I should see "Apocalypse Now" before "Zorro"
