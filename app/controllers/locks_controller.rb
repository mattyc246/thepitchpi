class LocksController < ApplicationController

  def index
    @user = params[:user_id]
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

  def group_points
    @user = User.find(params[:id])
    if params[:group] == "All"
      @lngmax = @user.locks.pluck(:longitude).max
      @lngmin = @user.locks.pluck(:longitude).min
      @latmax = @user.locks.pluck(:latitude).max
      @latmin = @user.locks.pluck(:latitude).min
    else
      @lngmax = @user.locks.where(group: params[:group]).pluck(:longitude).max
      @lngmin = @user.locks.where(group: params[:group]).pluck(:longitude).min
      @latmax = @user.locks.where(group: params[:group]).pluck(:latitude).max
      @latmin = @user.locks.where(group: params[:group]).pluck(:latitude).min
    end

    render json: {lngmax: @lngmax, lngmin: @lngmin, latmax: @latmax, latmin: @latmin }

  end

  def within_radius?
    @user = User.find(params[:id])
    @lock = @user.locks.find_by(ranking: "Main")
    if Geocoder::Calculations.distance_between([params[:lng],params[:lat]], [@lock.longitude, @lock.latitude]) > radius
    end
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

  def toggle_lock

    @locks = Lock.where(user_id: params[:user_id])
    lock = Lock.find(params[:toggle_id])

    if lock.status == "Locked"

      lock.status = "Unlocked"
      
      if lock.save
        
        host = ENV['RASPBERRY_PI_HOST']
        user = ENV['RASPBERRY_PI_USER']
        password = ENV['RASPBERRY_PI_PASSWORD']
        
        Net::SSH.start(host, user, password: password) do |ssh|
          
            output = ssh.exec!("cd Desktop; python lock_on.py")

            render json: { notice: "#{lock.group}'s #{lock.lock_name} has been unlocked" }

        end

      else

        render json: {notice: "Error! Please try again!"}

      end
      
    else

      lock.status = "Locked"

      if lock.save

        host = ENV['RASPBERRY_PI_HOST']
        user = ENV['RASPBERRY_PI_USER']
        password = ENV['RASPBERRY_PI_PASSWORD']
        
        Net::SSH.start(host, user, password: password) do |ssh|
          
            output = ssh.exec!("cd Desktop; python lock_off.py")

            render json: { notice: "#{lock.group}'s #{lock.lock_name} has been locked" }

        end


      else

        render json: {notice: "Error! Please try again!"}

      end
    end
  end

  private
  def lock_params
    params.require(:locks).permit(:lock_name, :location, :group, :longitude, :latitude)
  end

end
