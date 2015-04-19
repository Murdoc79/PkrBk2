class Season < ActiveRecord::Base  
  has_and_belongs_to_many :players
  has_many :games, :dependent => :destroy
  has_many :tables, :through => :games

  validates :number_of_games, :numericality => { :only_integer => true }
  validates :number_of_tables, :numericality => { :only_integer => true }
  validates :name, :presence => true

  def generate_schedule
    if !self.locked    
      (1..self.number_of_games).each do |game|
        current_game = Game.new(:number => game)
        (1..self.number_of_tables).each do |table|
          current_table = Table.new(:number => table)
          current_game.tables << current_table
        end
        self.games << current_game
      end
      self.locked = true
      self.save
    end
  end

  def games_played
    @games_played = 0
    self.games.order("number").each do |game|
      if game.finished? 
        @games_played += 1
      else
        break
      end
    end
    @games_played
  end 

  def games_to_display   
    @games_played = 0
    self.games.order("number").each do |game|
      if game.finished? || game.in_progress?
        @games_played += 1
      else
        break
      end
    end
    @games_played
  end

  
end
