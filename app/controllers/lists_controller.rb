class ListsController < ApplicationController
  before_action :authenticate_user!

  def update
    @list = current_user.list
    @list.commodities << list_params[:commodity_id] unless @list.commodities.include?(list_params[:commodity_id])
    @list.save
    redirect_back(fallback_location: root_path)
  end

  private

  def list_params
    params.require(:list).permit(:commodity_id)
  end
end
