class Artist < ActiveRecord::Base
	self.inheritance_column = nil

	BAND_TYPES = ["Acoustic", "Rock", "Blues", "Country", "Soul", "Gospel"]

	validates :name, presence: true
	validates :email, presence: true, uniqueness: true, email: true
	validates :type, inclusion: BAND_TYPES
	validates :password, presence: true, confirmation: true, length: {minimum: 6, too_short: "must have at least %{count} characters"}
	validates :password_confirmation, presence: true
end
