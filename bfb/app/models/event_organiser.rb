class EventOrganiser < ActiveRecord::Base

	validates :firstName, presence: true, length: {maximum: 100}
	validates :lastName, presence: true, length: {maximum:100}
	validates :email, presence: true, email: true
	validates :phoneNumber, presence: true, length: {is: 11}
	validates :password, presence: true, confirmation: true, length: {minimum: 6, too_short: "must have at least %{count} characters"}
	validates :password_confirmation, presence: true
end
