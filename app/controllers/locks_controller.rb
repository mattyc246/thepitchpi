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

  def group_points
    p params
    @lock = Lock.find(params[:id])
    coordinates = []
    # @locks.where(group: params[:group]).pluck(:longitude).max
    # @locks.where(group: params[:group]).pluck(:longitude).minlocks



  end

  private
  def lock_params
    params.require(:lock).permit(:lock_name, :location, :group)
  end
end
