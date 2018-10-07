class User < ApplicationRecord
  include Clearance::User

	validates :email, uniqueness: true, format: {with:  /(\w+)@(\w+).(\w{2,})/, message: "Invalid Email Address"}
	after_initialize :set_membership, on: [:create]
	  
end
