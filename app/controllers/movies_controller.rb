class MoviesController < ApplicationController

  helper_method :select_rating?
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = ['G','PG','PG-13','R']
    
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    @movies = Movie.all
    
    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:sort].nil? && !session[:sort].nil?)
      redirect_to movies_path("sort" => session[:sort], "ratings" => session[:ratings])
    elsif !params[:ratings].nil? || !params[:sort].nil?
      if !params[:ratings].nil?
        ratings = params[:ratings].keys
        return @movies = Movie.where(rating: ratings).order(session[:sort])
      else
        return @movies = Movie.all.order(session[:sort])
      end
    elsif !session[:ratings].nil? || !session[:sort].nil?
      redirect_to movies_path("ratings" => session[:ratings], "sort" => session[:sort], )
    else
      return @movies = Movie.all
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
  
  def select_rating?(rating)
    select_ratings = session[:ratings]
    return true if select_ratings.nil?
    select_ratings.include? rating
  end

end
