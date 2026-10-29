json.extract! movie, :id, :title, :rating, :description, :release_date, :director, :created_at, :updated_at
json.url movie_url(movie, format: :json)
