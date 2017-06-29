class AddSubIdToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :sub_id, :integer, :default => nil
  end
end
