class Movie < ApplicationRecord
    RATINGS = %w[G PG PG-13 R NC-17].freeze
    validates :title, presence: true
    validates :rating, inclusion: {in: RATINGS}
    validates :release_date, presence: true
end
