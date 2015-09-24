class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @movies = Movie.order(params[:sort])

    #HW2
    @all_ratings = ['G', 'PG', 'PG-13', 'R']

    session[:selected_ratings] ||= Hash.new
    session[:selected_order] ||= Hash.new 
    
    if(params.size == 2)
      params[:order]   ||= session[:selected_order] 
      params[:ratings] ||= session[:selected_ratings]
      redirect_to movies_path(params) and return
    end
   
    @rat = params[:ratings] 
    if !@rat.nil?
      session[:selected_ratings] = @rat 
    elsif !params[:commit].nil? 
      session[:selected_ratings] = Hash.new
    end
    
    @selected_ratings = session[:selected_ratings]  
    
    if params[:ratings]
      @checked_ratings = params[:ratings]
      @movies = Movie.where("rating IN (?)", @checked_ratings)
    else
      @movies = Movie.order(params[:sort]) 
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
