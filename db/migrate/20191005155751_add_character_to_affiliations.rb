class AddCharacterToAffiliations < ActiveRecord::Migration[5.2]
  def change
    add_reference :affiliations, :character, foreign_key: true
  end
end
