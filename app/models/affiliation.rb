class Affiliation < ApplicationRecord
  belongs_to :character

  validates :affiliation_description, presence: true

end