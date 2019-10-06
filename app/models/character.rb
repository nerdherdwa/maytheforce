class Character < ApplicationRecord
  has_many :locations
  has_many :affiliations

  validates :first_name, :species, :gender, presence: true
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      
      if !row["Affiliations"].nil?
        fname = row["Name"].split.first.titleize
        if row["Name"].split.count > 1
          lname = row["Name"].split[1..-1].join(' ').titleize
        end

        character = Character.find_or_create_by(
          first_name: fname,
          last_name: lname,
          species: row["Species"],
          gender: row["Gender"],
          weapon: row["Weapon"],
          vehicle: row["Vehicle"]
        )
        
        row["Location"].split(",").each do |pos|
          character.locations.find_or_create_by(
            location_description: pos.strip
          )
        end

        row["Affiliations"].split(",").each do |pos|
          character.affiliations.find_or_create_by(
            affiliation_description: pos.strip
          )
        end
      end

    end
  end

end