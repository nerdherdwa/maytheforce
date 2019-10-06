class Location < ApplicationRecord
  belongs_to :character

  validates :location_description, presence: true

end