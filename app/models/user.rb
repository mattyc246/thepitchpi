class User < ApplicationRecord
  include Clearance::User

	validates :email, uniqueness: true, format: {with:  /(\w+)@(\w+).(\w{2,})/, message: "Invalid Email Address"}
	after_initialize :set_membership, on: [:create]


	private

	def set_membership

		if self.subscription_status == nil

			self.subscription_status = false

		end
	end

end
