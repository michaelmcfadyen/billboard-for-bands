class PhoneNumberValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		unless value =~ /\A(0\d{10})\z/
			record.errors[attribute] << (options[:message] || "is not a phone number")
		end
	end
end