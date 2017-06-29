class CreatePlayerSeasonJoinTable < ActiveRecord::Migration
  def up
    create_table :players_seasons, :id => false do |t|
      t.integer :player_id
      t.integer :season_id
    end
  end

  def down
    drop_table :players_seasons
  end
end


