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

  private
  def lock_params
    params.require(:lock).permit(:lock_name, :location, :group, :longitude, :latitude)
  end
end
