class Location < ApplicationRecord
	validates :zip, :country_code, presence: true
end
