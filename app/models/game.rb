class Game < ActiveRecord::Base
  belongs_to :season
  has_many :tables, :dependent => :destroy
  has_many :seats, :through => :tables 

  def previous_game_concluded?(game)
    @season = game.season    
    @result = true
    if game.number != 1
      @previous_game = @season.games.where(:number => (game.number - 1)).first
      @previous_tables = @previous_game.tables
      @result = true
      @previous_tables.each do |table|
        if table.players_still_playing.size != 0 || table.seats.size == 0
          @result = false
        end
      end
    end
    @result
  end
  
  def current_game_not_started?(game)
    @tables = game.tables
    @result = true
    @tables.each do |table|
      if table.players_finished.size != 0
        @result = false
      end
    end
    @result
  end
  
  def can_seat_players?
    #seat players option is available if the last game is concluded and 
    #this game hasn't started yet
    current_game_not_started?(self) && previous_game_concluded?(self)   
  end

  def finished?
    @result = true
    self.tables.each do |table|
      if table.players_still_playing.size != 0 || table.seats.size == 0
        @result = false
      end
    end
    @result
  end

  def in_progress?
    @result = false
    self.tables.each do |table|
      if table.players_still_playing.size != 0
        @result = true
      end
    end
    @result  
  end
        
end
