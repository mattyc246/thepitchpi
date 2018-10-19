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

    @lock = Lock.find(params[:id])

  end

  def update
    @lock = Lock.find(params[:id])
    @lock.update(lock_params)
    redirect_to user_lock_path
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
    radius = 0.015
    @user = User.find(current_user.id)
    @lock = @user.locks.find_by(tracking: true)
    @distance = Geocoder::Calculations.distance_between([params[:current_lng],params[:current_lat]], [@lock.longitude, @lock.latitude])
    @in_range = "unchanged"

    if @lock && @lock.status == "Unlocked"
        if @user.in_range == true
          if @distance > radius
              @in_range = "false"
                Twilio::REST::Client.new.messages.create({
                from: ENV['twilio_phone_number'],
                to: '+60102362993',
                body: "Your #{@lock.group}, #{@lock.lock_name}, is UNLOCKED and you are more than 150 meters way. We have locked it for you!"
                })

                @user.update(in_range: false)

                if @lock.id == 1
                  host = ENV['RASPBERRY_PI_HOST']
                else
                  host = "123.123.3.3.1"
                end
                user = ENV['RASPBERRY_PI_USER']
                password = ENV['RASPBERRY_PI_PASSWORD']
                port = ENV['RASPBERRY_PI_PORT']

                Net::SSH.start(host, user, password: password, port: port) do |ssh|

                    output = ssh.exec!("cd Desktop; python lock_controller.py lock")

                    status = output.split

                    if status[0].to_s == "Locked"

                      render json: { status: @lock.status, notice: "#{lock.group}'s #{lock.lock_name} has been locked" }

                    else

                      render json: { status: @lock.status, notice: "#{lock.group}'s #{lock.lock_name} has been left open! Close the door!" }

                    end


                end
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

    @status_db = @user.in_range

    render json: {lng: params[:current_lng], lat: params[:current_lat], acc: params[:current_acc], distance: @distance, in_range: @in_range, status_db: @status_db}

  end

  def status_check

    @lock = Lock.find(params[:toggle_id])

    lock_status = @lock.status

    # Return will be Open or Closed
    render :json => {status: lock_status}
  end

  def toggle_lock

    @locks = Lock.where(user_id: params[:user_id])
    lock = Lock.find(params[:toggle_id])


    # bypass all if not lock id 1-----------------------------------
    if lock.id == 1
    # bypass all if not lock id 1-----------------------------------

    if lock.status == "Locked"

      lock.status = "Unlocked"

      if lock.save

        if lock.id == 1
          host = ENV['RASPBERRY_PI_HOST']
        else
          host = "123.123.3.3.1"
        end
        user = ENV['RASPBERRY_PI_USER']
        password = ENV['RASPBERRY_PI_PASSWORD']
        port = ENV['RASPBERRY_PI_PORT']


        Net::SSH.start(host, user, password: password, port: port) do |ssh|

            output = ssh.exec!("cd Desktop; python lock_controller.py unlock")

            status = output.split

            if status[0].to_s == "Unlocked"

              render json: { status: lock.status, notice: "#{lock.group}'s #{lock.lock_name} has been unlocked" }

            else

              render json: { status: lock.status, notice: "#{lock.group}'s #{lock.lock_name} has been left open! Close the door! "}

            end

        end

      else

        render json: {notice: "Error! Please try again!"}

      end

    else

      lock.status = "Locked"

      if lock.save

        if lock.id == 1
          host = ENV['RASPBERRY_PI_HOST']
        else
          host = "123.123.3.3.1"
        end
        user = ENV['RASPBERRY_PI_USER']
        password = ENV['RASPBERRY_PI_PASSWORD']
        port = ENV['RASPBERRY_PI_PORT']

        Net::SSH.start(host, user, password: password, port: port) do |ssh|

            output = ssh.exec!("cd Desktop; python lock_controller.py lock")

            status = output.split

            if status[0].to_s == "Locked"

              render json: { status: lock.status, notice: "#{lock.group}'s #{lock.lock_name} has been locked" }

            else

              render json: { status: lock.status, notice: "#{lock.group}'s #{lock.lock_name} has been left open! Close the door!" }

            end


        end


      else

        render json: {notice: "Error! Please try again!"}

      end
    end


    # bypass all if not lock id 1-----------------------------------
    else
      if lock.status == "Locked"
        lock.update(status:"Unlocked")
        render json: { status: "Unlocked", notice: "#{lock.group}'s #{lock.lock_name} has been unlocked" }
      elsif lock.status == "Unlocked"
        lock.update(status:"Locked")
      render json: { status: "Locked", notice: "#{lock.group}'s #{lock.lock_name} has been locked" }
    end
  end
    # bypass all if not lock id 1-----------------------------------

  end

  def lock_around_the_clock

    current_lock = Lock.find(params[:lock_id])

    if current_lock.tracking == true

      current_lock.tracking = false

      if current_lock.save

        render json: {tracking_set: current_lock.tracking}

      else

        flash[:notice] = "Internal Error! Please contact the Locker Admin"

      end

    elsif current_lock.tracking == false

      current_lock.tracking = true

      if current_lock.save

        render json: {tracking_set: current_lock.tracking}

      else

        flash[:notice] = "Internal Error! Please contact the Locker Admin"

      end

    end

  end

  private
  def lock_params
    params.require(:locks).permit(:id, :user_id, :lock_name, :location, :group, :longitude, :latitude)
  end

end
