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

  def distance_check
    radius = 0.02
    @user = User.find(current_user.id)
    @lock = @user.locks.find_by(tracking: true)
    @distance = Geocoder::Calculations.distance_between([params[:current_lng],params[:current_lat]], [@lock.longitude, @lock.latitude])
    @in_range = "unchanged"

    if @lock && @lock.status == "Unlocked"
        if @user.in_range == true
          if @distance > radius
              @in_range = "false"
              #   Twilio::REST::Client.new.messages.create({
              #   from: ENV['twilio_phone_number'],
              #   to: 'your number',
              #   body: "Your #{@lock.group}, #{@lock.lock_name}, is UNLOCKED and you are more than 500 meters way. Lock it? https://www.google.com/"
              #   })
                @user.update(in_range: false)
            end
          else
            if @distance < radius
              @in_range = "true"
              @user.update(in_range: true)
            end
          end
      else @lock && @lock.status == "Locked"
        if @distance > radius
          @in_range = "locked"
          @user.update(in_range: true) if !@user.in_range
        end
    end
    # byebug

    @status_db = @user.in_range

    render json: {lng: params[:current_lng], lat: params[:current_lat], acc: params[:current_acc], distance: @distance, in_range: @in_range, status_db: @status_db}

  end

  def status_check

    @lock_status = ""

    host = ENV['RASPBERRY_PI_HOST']
    user = ENV['RASPBERRY_PI_USER']
    password = ENV['RASPBERRY_PI_PASSWORD']
    port = ENV['RASPBERRY_PI_PORT']

    Net::SSH.start(host, user, password: password, port: port) do |ssh|
      output = ssh.exec!("cd Desktop; python lock_controller.py status")
      @lock_status = output.split
    end
    # Return will be Open or Closed
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
        port = ENV['RASPBERRY_PI_PORT']

        Net::SSH.start(host, user, password: password, port: port) do |ssh|
          
            output = ssh.exec!("cd Desktop; python lock_controller.py unlock")

            status = output.split

            if status[0].to_s == "Unlocked"

              render json: { notice: "#{lock.group}'s #{lock.lock_name} has been unlocked" }

            else

              render json: { notice: "#{lock.group}'s #{lock.lock_name} has been left open! Close the door! "}

            end

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
        port = ENV['RASPBERRY_PI_PORT']
        
        Net::SSH.start(host, user, password: password, port: port) do |ssh|
          
            output = ssh.exec!("cd Desktop; python lock_controller.py lock")

            status = output.split

            if status[0].to_s == "Locked"

              render json: { notice: "#{lock.group}'s #{lock.lock_name} has been locked" }

            else

              render json: { notice: "#{lock.group}'s #{lock.lock_name} has been left open! Close the door!" }
              
            end


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
