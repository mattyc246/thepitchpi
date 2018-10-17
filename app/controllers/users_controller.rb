class UsersController < ApplicationController

	def new

		@user = User.new

	end

	def create	

		user = User.new(user_params)

		if user.save

			flash[:notice] = "Account successfully registered!"
			redirect_to '/'

		else

			flash[:alert] = "Unable to register account, check details and retry!"
			render :new

		end

	end

	def show

		@user = User.find(current_user.id)
		
	end

	def update

	end

	def destroy

	end

	private

	def user_params

		params.require(:user).permit(:name, :email, :password, :subscription_status)

	end

end
