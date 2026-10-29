# rails_helper loads spec_helper (SimpleCov + RSpec config) and then Rails.
require "rails_helper"

RSpec.describe Movie, type: :model do
  def create_movie(title, director)
    Movie.create!(title: title, rating: "PG", release_date: "1980-01-01", director: director)
  end

  describe "#others_by_same_director" do
    let!(:star_wars)    { create_movie("Star Wars", "George Lucas") }
    let!(:thx_1138)     { create_movie("THX-1138", "George Lucas") }
    let!(:blade_runner) { create_movie("Blade Runner", "Ridley Scott") }
    let!(:alien)        { create_movie("Alien", nil) }

    it "finds movies by the same director" do
      expect(star_wars.others_by_same_director).to include(thx_1138)
    end

    it "does not find movies by different directors" do
      expect(star_wars.others_by_same_director).not_to include(blade_runner, alien)
    end

    it "does not include the movie itself" do
      expect(star_wars.others_by_same_director).not_to include(star_wars)
    end

    # Sad path at the model level: without director info there is nothing
    # to match on (in particular, it must not match other movies whose
    # director is also unknown).
    it "finds no movies when the movie has no director info" do
      create_movie("Another movie without director", nil)

      expect(alien.others_by_same_director).to be_empty
    end
  end

  describe "validations" do
    it "is valid with a title, a known rating and a release date" do
      expect(Movie.new(title: "Alien", rating: "R", release_date: "1979-05-25")).to be_valid
    end

    it "requires a title" do
      expect(Movie.new(rating: "R", release_date: "1979-05-25")).not_to be_valid
    end

    it "requires one of the MPAA ratings" do
      expect(Movie.new(title: "Alien", rating: "X", release_date: "1979-05-25")).not_to be_valid
    end

    it "requires a release date" do
      expect(Movie.new(title: "Alien", rating: "R")).not_to be_valid
    end
  end
end
