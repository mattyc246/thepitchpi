class User < ApplicationRecord
  include Clearance::User

	validates :email, presence: true, uniqueness: true, format: {with:  /(\w+)@(\w+).(\w{2,})/, message: "Invalid Email Address"}
	validates :name, presence: true
	validates :password, length: {in: 8..20}
	after_initialize :set_membership, on: [:create]


	private

	def set_membership

		if self.subscription_status == nil

			self.subscription_status = false

		end
	end

end
