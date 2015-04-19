class SeasonsController < ApplicationController
  layout :pick_layout

  # before_filter :require_login

  # GET /seasons
  # GET /seasons.json
  def index
    @seasons = Season.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seasons }
    end
  end

  def show
    @season = Season.find(params[:id])
    @players = @season.players
    @all_players = Player.all
    @subs = @all_players - @players
    @players_total_points = {}

    @games = @season.games.order(:number)
    @games_to_display = @games[0..(@season.games_to_display - 1)]

    @players = @players.sort { |x, y| x.total_points(@season)[0] <=> y.total_points(@season)[0] }  
    @players = @players.reverse  

    if !current_user
      render 'season_results'
    end
  end

  # GET /seasons/new
  # GET /seasons/new.json
  def new
    @season = Season.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @season }
    end
  end

  # GET /seasons/1/edit
  def edit
    @season = Season.find(params[:id])
  end

  # POST /seasons
  # POST /seasons.json
  def create
    @season = Season.new(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to @season, notice: 'Season was successfully created.' }
        format.json { render json: @season, status: :created, location: @season }
      else
        format.html { render action: "new" }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @season = Season.find(params[:id])
    updates = season_update_params
    if @season.locked
      updates.delete("number_of_games")
      updates.delete("number_of_tables")
    end
    if @season.update_attributes(updates)
      redirect_to @season, notice: 'Season was successfully updated.'        
    else
      render action: "edit_details" 
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @season = Season.find(params[:id])
    @season.destroy

    respond_to do |format|
      format.html { redirect_to seasons_url }
      format.json { head :ok }
    end
  end

  def edit_players
    @season = Season.find(params[:id])
    @players_in_this_season = @season.players 
    @players = Player.order('name')
  end

  def update_players
    @players = Player.all
    @season = Season.find(params[:id])
    @players.each do |player|
      if params[player.id.to_s] == "1"
        player.add_to_season(@season)
      else
        player.remove_from_season(@season)
      end
    end
    redirect_to @season
  end

  def generate_schedule
    @season = Season.find(params[:id])
    @players = @season.players
  end

  def run_generate_schedule
    @season = Season.find(params[:id])
    @season.generate_schedule
    redirect_to @season
  end

  private

  def season_params
    params.require(:season).permit(:name)
  end     

  def season_update_params
    params.require(:season).permit(:name, :number_of_games, :number_of_tables, :notes, :visible)
  end
end




