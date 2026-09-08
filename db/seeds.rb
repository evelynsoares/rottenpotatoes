# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


movies = [
        { title: "Toy Story", rating: "G",
        release_date: Date.new(1995, 11, 22),
        description: "Brinquedos ganham vida." },
        { title: "The Matrix", rating: "R",
        release_date: Date.new(1999, 3, 31),
        description: "Um programador descobre a realidade." },
        { title: "Star Wars", rating: "PG",
        release_date: Date.new(1977, 5, 25),
        description: "Uma aventura em uma galáxia distante." }
    ]
    movies.each do |attributes|
        Movie.find_or_create_by!(title: attributes[:title]) do |movie|
        movie.assign_attributes(attributes)
    end
end