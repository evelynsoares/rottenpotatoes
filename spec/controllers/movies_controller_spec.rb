# rails_helper loads spec_helper (SimpleCov + RSpec config) and then Rails.
require "rails_helper"

RSpec.describe MoviesController, type: :controller do
  def create_movie(title:, director: nil, rating: "PG", release_date: "1980-01-01")
    Movie.create!(title:, director:, rating:, release_date:)
  end

  describe "GET #similar (Find Movies With Same Director)" do
    context "when the specified movie has a director" do
      let(:star_wars) { create_movie(title: "Star Wars", director: "George Lucas") }
      let(:same_director_movies) { [ create_movie(title: "THX-1138", director: "George Lucas") ] }

      # Seam: the controller receives *this* Star Wars object, so we can
      # check which model method it calls and control what that returns,
      # testing the controller in isolation from the model's query.
      before do
        allow(Movie).to receive(:find).with(star_wars.id.to_s).and_return(star_wars)
        allow(star_wars).to receive(:others_by_same_director).and_return(same_director_movies)
        get :similar, params: { id: star_wars.id }
      end

      it "calls the model method that finds movies with the same director" do
        expect(star_wars).to have_received(:others_by_same_director)
      end

      it "selects the Similar Movies template for rendering" do
        expect(response).to render_template(:similar)
      end

      it "makes the movies with the same director available to that template" do
        expect(assigns(:movies)).to eq(same_director_movies)
      end
    end

    context "when the specified movie has no director" do
      let(:alien) { create_movie(title: "Alien", director: nil) }

      before do
        allow(Movie).to receive(:find).with(alien.id.to_s).and_return(alien)
        allow(alien).to receive(:others_by_same_director)
        get :similar, params: { id: alien.id }
      end

      it "does not look for movies with the same director" do
        expect(alien).not_to have_received(:others_by_same_director)
      end

      it "redirects to the home page" do
        expect(response).to redirect_to(movies_path)
      end

      it "warns that the movie has no director info" do
        expect(flash[:warning]).to eq("'Alien' has no director info")
      end
    end
  end

  describe "GET #index" do
    let!(:zorro)   { create_movie(title: "Zorro", rating: "PG") }
    let!(:aladdin) { create_movie(title: "Aladdin", rating: "G") }
    let!(:alien)   { create_movie(title: "Alien", rating: "R") }

    it "shows movies of every rating when no filter was submitted" do
      get :index
      expect(assigns(:movies)).to include(zorro, aladdin, alien)
    end

    it "shows only the checked ratings once the filter is submitted" do
      get :index, params: { ratings_submitted: "1", ratings: { "PG" => "1", "R" => "1" } }
      expect(assigns(:movies)).to include(zorro, alien)
      expect(assigns(:movies)).not_to include(aladdin)
    end

    it "sorts the movies by the requested column" do
      get :index, params: { sort_by: "title" }
      expect(assigns(:movies).to_a & [ zorro, aladdin, alien ]).to eq([ aladdin, alien, zorro ])
    end
  end

  describe "POST #create" do
    it "creates the movie and shows it" do
      expect {
        post :create, params: { movie: { title: "Alien", rating: "R", release_date: "1979-05-25", director: "Ridley Scott" } }
      }.to change(Movie, :count).by(1)

      expect(Movie.last.director).to eq("Ridley Scott")
      expect(response).to redirect_to(movie_path(Movie.last))
    end

    it "shows the form again when the movie is invalid" do
      expect {
        post :create, params: { movie: { title: "", rating: "R", release_date: "1979-05-25" } }
      }.not_to change(Movie, :count)

      expect(response).to render_template(:new)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH #update" do
    let(:alien) { create_movie(title: "Alien", rating: "R") }

    it "saves the director info" do
      patch :update, params: { id: alien.id, movie: { director: "Ridley Scott" } }

      expect(alien.reload.director).to eq("Ridley Scott")
      expect(response).to redirect_to(movie_path(alien))
    end

    it "updates the title" do
      patch :update, params: { id: alien.id, movie: { title: "Aliens" } }

      expect(alien.reload.title).to eq("Aliens")
    end

    it "shows the form again when the changes are invalid" do
      patch :update, params: { id: alien.id, movie: { title: "" } }

      expect(alien.reload.title).to eq("Alien")
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE #destroy" do
    it "removes the movie and goes back to the movie list" do
      alien = create_movie(title: "Alien")

      expect { delete :destroy, params: { id: alien.id } }.to change(Movie, :count).by(-1)
      expect(response).to redirect_to(movies_path)
    end
  end

  describe "POST #search_tmdb" do
    it "warns that the movie was not found and goes back to the movie list" do
      post :search_tmdb, params: { search_terms: "Movie That Does Not Exist" }

      expect(flash[:warning]).to eq("'Movie That Does Not Exist' was not found in TMDb.")
      expect(response).to redirect_to(movies_path)
    end
  end
end
