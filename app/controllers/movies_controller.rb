class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy similar ]

  # GET /movies or /movies.json
  #
  # Filtro por classificação (ratings[]=PG&ratings[]=R...): sem o parâmetro,
  # todas as classificações são exibidas. O filtro e a ordenação são
  # independentes e podem ser combinados.
  def index
    @all_ratings = Movie::RATINGS
    @ratings_to_show = params[:ratings].present? ? Array(params[:ratings]) & @all_ratings : @all_ratings
    @sort = params[:sort_by]
    @selected_ratings = selected_ratings
    @movies = Movie.where(rating: @selected_ratings)
    @movies = @movies.order(@sort) if Movie::RATINGS_SORT_COLUMNS.include?(@sort)
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/1/similar
  #
  # "Find Movies With Same Director". O sad path (filme sem diretor) é
  # tratado aqui: volta para a lista de filmes com um aviso.
  def similar
    if @movie.director.blank?
      flash[:warning] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    else
      @movies = @movie.others_by_same_director
    end
  end

  # POST /movies/search_tmdb
  #
  # Ainda não há integração real com a API do TMDb (isso seria implementado
  # futuramente via TDD). Por enquanto, o método é "hardwired" para sempre
  # falhar, apenas para permitir validar o cenário de sad path do TMDb:
  # "Try to add nonexistent movie".
  def search_tmdb
    flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
    redirect_to movies_path
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @movie.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, notice: "Movie was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # With no filter submitted every rating is shown; once the ratings form
    # is submitted, only the checked ones are (possibly none).
    def selected_ratings
      return Movie::RATINGS unless params[:ratings_submitted]

      (params[:ratings]&.keys || []) & Movie::RATINGS
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :rating, :description, :release_date, :director ])
    end
end
