class Lock < ApplicationRecord
  belongs_to :user

  validates :lock_name, presence: true
  reverse_geocoded_by :latitude, :longitude,
          :address => :location
          after_validation :reverse_geocode


end
