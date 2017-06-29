class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :season_id
      t.integer :number
      t.date :date

      t.timestamps
    end
  end
end
