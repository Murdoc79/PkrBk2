class AddFieldsToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :number_of_games, :integer, :default => 0
    add_column :seasons, :number_of_tables, :integer, :default => 0
    add_column :seasons, :notes, :text
    add_column :seasons, :locked, :boolean, :default => false
  end
end
