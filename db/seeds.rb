movies = [
  {
    title: "Toy Story",
    rating: "G",
    release_date: Date.new(1995, 11, 22),
    description: "Brinquedos ganham vida."
  },
  {
    title: "The Matrix",
    rating: "R",
    release_date: Date.new(1999, 3, 31),
    description: "Um programador descobre a realidade."
  },
  {
    title: "Star Wars",
    rating: "PG",
    release_date: Date.new(1977, 5, 25),
    description: "Uma aventura em uma galáxia distante."
  }
]

movies.each do |attributes|
  Movie.find_or_create_by!(title: attributes[:title]) do |movie|
    movie.assign_attributes(attributes)
  end
end
