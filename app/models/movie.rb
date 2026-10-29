class Movie < ApplicationRecord
    RATINGS = %w[G PG PG-13 R NC-17].freeze
    RATINGS_SORT_COLUMNS = %w[title release_date].freeze
    validates :title, presence: true
    validates :rating, inclusion: { in: RATINGS }
    validates :release_date, presence: true

    # "Find Movies With Same Director": the other movies directed by the
    # same person. Without director info there is nothing to match on, so
    # no movies are returned (instead of every movie with no director).
    def others_by_same_director
      return Movie.none if director.blank?

      Movie.where(director: director).where.not(id: id)
    end
end
