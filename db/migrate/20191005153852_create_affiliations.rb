class CreateAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliations do |t|
      t.string :affiliation_description
    end
  end
end
