class ChangePeopleToCharacters < ActiveRecord::Migration[5.2]
  def change
    rename_table :people, :characters
  end
end
