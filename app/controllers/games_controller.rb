class GamesController < ApplicationController
  layout :pick_layout
  before_filter :require_login, :except => :show


  def index
    @season = Season.find(params[:season_id])
    @games = @season.games.order('number')
  end


  def show
    @game = Game.find(params[:id])
    @season = Season.find(params[:season_id])
    @players = Player.all
    @name_lookup = Hash.new
    @players.each do |player|
      @name_lookup[player.id] = player.name
    end
  end

  def set_subs
    @season = Season.find(params[:season_id])
    @game = Game.find(params[:id])
    @tables = @game.tables
    @season_players = @season.players
    @all_players = Player.all
    @subs = @all_players - @season_players
    @subs_list = [["No Sub", 0]] + @subs.map { |player| [player.name, player.id] }
  end

  def update_subs
    @seat = Seat.find(params[:seat_id])
    if params[:player_id] == "0"
      @seat.update_attributes(:sub_id => nil)
    else
      @seat.update_attributes(:sub_id => params[:player_id])
    end
    redirect_to set_subs_season_game_path(params[:season_id], params[:id])
  end

  def edit
    
  end

  def seat_players
    @season = Season.find(params[:season_id])
    @game = Game.find(params[:id])
    @tables = @game.tables
    @players = @season.players.order("name")
  end

  def update_seating
    @season = Season.find(params[:season_id])
    @game = Game.find(params[:id])
    @players = @season.players
    
    if @game.seats.size > 0 
      @game.seats.each do |seat|
        seat.update_attributes(:table_id => params[seat.player_id.to_s])
      end
    else
      @players.each do |player|
        #player is the hash key for the table number
        Seat.create(:player_id => player.id, :table_id => params[player.id.to_s])
      end
    end
    redirect_to season_games_path(@season) 
  end  

  def select_place
    @season = Season.find(params[:season_id])
    @game = Game.find(params[:id])
    @tables = @game.tables
        
    @games = @season.games.order(:number)
    @games_to_display = @games[0..(@season.games_to_display - 1)]
    @players = @season.players
    @players = @players.sort { |x, y| x.total_points(@season)[0] <=> y.total_points(@season)[0] }  
    @players = @players.reverse  
    
  end

  def update_place
    @season = Season.find(params[:season_id])
    @game = Game.find(params[:id])
    @table = Table.find(params[:table_id])

    if params[:undo] == '1'
      if @table.players_still_playing.size == 0
        @seat = Seat.where(:table_id => params[:table_id]).order(:place).first
        @seat.update_attributes(:place => nil)
      end
      @seat = Seat.where(:table_id => params[:table_id]).order(:place).first
      @seat.update_attributes(:place => nil)
    else
      @seat = Seat.where(:player_id => params[:player_id], :table_id => params[:table_id]).first
      @place = @table.players.size - @table.players_finished.size
      @seat.update_attributes(:place => @place)
      @players_left = @table.players_still_playing
      if @players_left.size == 1 
        @first_place = @players_left.first
        @seat = Seat.where(:player_id => @first_place.id, :table_id => params[:table_id]).first
        @seat.update_attributes(:place => 1)
      end

    end 

    redirect_to select_place_season_game_path(@season, @game)

  end


  def update
    
    @game = Game.find(params[:id])
    @game.update_attributes(game_update_params)
    redirect_to season_games_path(@game.season) 

  end

  private

  def game_update_params
    params.require(:game).permit(:date)
  end  

end






