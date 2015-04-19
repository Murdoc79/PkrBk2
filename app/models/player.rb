class Player < ActiveRecord::Base
  has_and_belongs_to_many :seasons
  has_many :seats
  has_many :tables, :through => :seats

  def is_in_season?(season)
    self.seasons.include?(season)
  end

  def add_to_season(season)
    if self.is_in_season?(season) == false
      self.seasons << season
    end
  end

  def remove_from_season(season)
    if self.is_in_season?(season)
      self.seasons.delete(season)
    end
  end

  def is_at_table?(table)
    seat = Seat.where(:player_id => self.id, :table_id => table.id)
    seat.size == 1
  end

  #TODO should be for one season
  def total_points(season)
    @total = []
    @total[0] = 0 
    @total[1] = 0  
    self.seats_in_season(season).each do |seat|
      if seat.table.game.in_progress?      
        if seat.place 
          @total[1] += (9 - seat.place)
        end
      else
        if seat.place
          @total[0] += (9 - seat.place)
        end
      end
    end
    @total  
  end  

  def points_in_game(game)
    seat = game.seats.where(:player_id => self.id).first
    @return    
    if seat
      if seat.place
        @return = 9 - seat.place
      else
        @return = ""
      end
    else
      @return = ""
    end
    @return
  end  

  def tables_to_display(season)
    Table.find_by_sql("SELECT tables.id, tables.game_id, tables.number FROM players, seats, tables, games, seasons WHERE
      seats.player_id = players.id AND seats.table_id = tables.id AND 
      tables.game_id = games.id AND games.season_id = seasons.id AND    
      players.id = #{self.id} AND seasons.id = #{season.id}
      ORDER BY games.number ASC;")
  end

  def seats_in_season(season)
    Seat.find_by_sql(" SELECT seats.place, seats.id, seats.player_id, seats.table_id 
      FROM seats, players, tables, games, seasons WHERE 
      seats.player_id = players.id AND tables.id = seats.table_id AND
      tables.game_id = games.id AND games.season_id = seasons.id AND
      players.id = #{self.id} AND seasons.id = #{season.id}")
  end
end
