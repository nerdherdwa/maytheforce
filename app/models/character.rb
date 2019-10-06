class Character < ApplicationRecord
  include PgSearch

  has_many :locations
  has_many :affiliations

  validates :first_name, :species, :gender, presence: true

  filterrific(
    default_filter_params: { :sorted_by => 'Character Name_desc'},
    available_filters: [
      :search_query,
      :sorted_by,
    ],
  )

  pg_search_scope :character_search,
    against: [:first_name, :last_name, :vehicle, :gender, :species, :weapon],
    associated_against: { locations: [:location_description], affiliations: [:affiliation_description] },
    using: { tsearch: { any_word: true, prefix: true, dictionary: 'english' } }

  scope :search_query, ->(query) { character_search(query) }
  scope :sorted_by, ->(sort_option) {
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    characters = Character.arel_table
    locations = Location.arel_table
    affiliations = Affiliation.arel_table
    case sort_option.to_s
    when /^Character Name_/
      order("LOWER(characters.last_name) #{direction}, LOWER(characters.first_name) #{direction}")
    when /^Gender_/
      order("LOWER(characters.gender) #{direction}")
    when /^Species_/
      order("LOWER(characters.species) #{direction}")
    when /^Weapon_/
      order("LOWER(characters.weapon) #{direction}")
    when /^Vehicle_/
      order("LOWER(characters.vehicle) #{direction}")
    when /^Location_/
      
    when /^Affiliation_/
      
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      
      if !row["Affiliations"].nil?

        fname = row["Name"].split.first
        if row["Name"].split.count > 1
          lname = row["Name"].split[1..-1].join(' ').humanize.gsub(/\b('?[a-z])/) { $1.capitalize }
        end

        character = Character.find_or_create_by(
          first_name: row["Gender"]=="Other" ? fname.upcase : fname.humanize.gsub(/\b('?[a-z])/) { $1.capitalize },
          last_name: lname,
          species: row["Species"],
          gender: row["Gender"],
          weapon: row["Weapon"],
          vehicle: row["Vehicle"]
        )
        
        row["Location"].split(",").each do |pos|
          character.locations.find_or_create_by(
            location_description: pos.strip.humanize.gsub(/\b('?[a-z])/) { $1.capitalize }
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

  def location_string
    locations.map(&:location_description).flatten.join(', ')
  end

  def affiliation_string
    affiliations.map(&:affiliation_description).flatten.join(', ')
  end

  def character_name
    "#{first_name} #{last_name}"
  end


  def self.options_for_sorted_by
    [
      ['Name (z-a)', 'Character Name_desc'],
      ['Name (a-z)', 'Character Name_asc'],
      ['Location (z-a)', 'Location_desc'],
      ['Location (a-z)', 'Location_asc'],
      ['Affiliation (z-a)', 'Affiliation_desc'],
      ['Affiliation (a-z)', 'Affiliation_asc'],
      ['Gender (z-a)', 'Gender_desc'],
      ['Gender (a-z)', 'Gender_asc'],
      ['Species (z-a)', 'Species_desc'],
      ['Species (a-z)', 'Species_asc'],
      ['Weapon (z-a)', 'Weapon_desc'],
      ['Weapon (a-z)', 'Weapon_asc'],
      ['Vehicle (z-a)', 'Vehicle_desc'],
      ['Vehicle (a-z)', 'Vehicle_asc']
    ]
  end
end