require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "precisa ter titulo" do
    movie = Movie.new(rating: "PG", release_date: Date.current)

    assert_not movie.valid?
    assert_includes movie.errors[:title], "can't be blank"
  end

  test "aceita classificações conhecidas" do
    movie = Movie.new(title: "Filme", rating: "INVALIDA", release_date: Date.current)

    assert_not movie.valid?
  end
end
