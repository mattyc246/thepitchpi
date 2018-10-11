class User < ApplicationRecord
  include Clearance::User
  	has_many :locks

	validates :email, uniqueness: true, format: {with:  /(\w+)@(\w+).(\w{2,})/, message: "Invalid Email Address"}
	validates :email, presence: true, on:[:create]
	validates :name, presence: true, on:[:create]
	validates :password, length: {in: 8..20}, on: [:create]
	after_initialize :set_membership, on: [:create]




	private

	def set_membership

		if self.subscription_status == nil

			self.subscription_status = false

		end
	end

end
