class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :player_id
      t.integer :table_id
      t.integer :place

      t.timestamps
    end
  end
end
