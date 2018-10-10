class LocksController < ApplicationController
  def index
    @locks = Lock.where(user_id: params[:user_id])
  end

  def new
  end

  def create
    @lock = Lock.new(lock_params)
    @lock.user_id = current_user.id
    @lock.save
    redirect_to user_locks_path

  end

  def show
    @lock = Lock.find(params[:id])
  end

  def edit
  end

  def destroy
  end

  def status_check

    @lock_status = ""

    host = ENV['RASPBERRY_PI_HOST']

    user = ENV['RASPBERRY_PI_USER']

    password = ENV['RASPBERRY_PI_PASSWORD']

    Net::SSH.start(host, user, password: password) do |ssh|
      
      output = ssh.exec!("cd Desktop; python button_press.py")
       
      @lock_status = output.split

    end
    
    render :json => {status: @lock_status[0].to_s}

  end

  private
  def lock_params
    params.require(:lock).permit(:lock_name, :location, :group)
  end
end
