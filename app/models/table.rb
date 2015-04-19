class Table < ActiveRecord::Base
  belongs_to :game
  has_many :seats, :dependent => :destroy
  has_many :players, :through => :seats

  def players_still_playing 
    Player.find_by_sql("SELECT players.name, players.id FROM players, seats, tables WHERE
      seats.player_id = players.id AND seats.table_id = tables.id AND
        tables.id = #{self.id} AND seats.place IS NULL")
  end

  def players_finished
    Player.find_by_sql("SELECT players.name, players.id FROM players, seats, tables WHERE
      seats.player_id = players.id AND seats.table_id = tables.id AND
        tables.id = #{self.id} AND seats.place IS NOT NULL 
        ORDER BY seats.place ASC;")
  end

  def seats_in_order_of_place
    @players_finished_size = self.players_finished.size
    @seats_at_table = self.seats.order("place")
    if self.players_still_playing.size != 0    
      @seats_finished = @seats_at_table.slice!(0..(@players_finished_size - 1))
      @seats_at_table += @seats_finished 
    end
    @seats_at_table  
  end


end
