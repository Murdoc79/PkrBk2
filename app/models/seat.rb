class Seat < ActiveRecord::Base
  belongs_to :table
  belongs_to :player

  def sub_name
    if sub_id == nil
      ""
    else
      Player.find(sub_id).name
    end
  end
end