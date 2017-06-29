class AddVisibleToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :visible, :boolean, :default => false
  end
end
