class AddCharacterToLocations < ActiveRecord::Migration[5.2]
  def change
    add_reference :locations, :character, foreign_key: true
  end
end
