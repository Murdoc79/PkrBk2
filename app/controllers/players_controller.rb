class PlayersController < ApplicationController 
  layout :pick_layout
  
  # before_filter :require_login


  # GET /players
  # GET /players.json
  def index
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  def show
    @player = Player.find(params[:id])
    if params[:season_id]
      @season = Season.find(params[:season_id])
      @games = @season.games.order(:number)
      @games_to_display = @games[0..(@season.games_to_display - 1)]
      @tables_to_display = @player.tables_to_display(@season)
      @players = Player.all      
      @name_lookup = Hash.new
      @players.each do |player|
        @name_lookup[player.id] = player.name
      end
      render :season_results      
    end
  end

  # GET /players/new
  # GET /players/new.json
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :ok }
    end
  end

  private

  def player_params
    params.require(:player).permit(:email, :name)
  end


end



