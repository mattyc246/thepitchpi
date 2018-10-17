class WelcomeController < ApplicationController

  def index

  	if current_user
  	
  		@user = User.find(current_user.id)

  	end

  end

  def easter_egg

  	if current_user && current_user.subscription_status == true

  		@user = User.find(current_user.id)

  	else

  		flash[:notice] = "You are not ready to be a lockstar!"
  		redirect_to root_path
  		
  	end

  end

  def merch

  end
  
end
