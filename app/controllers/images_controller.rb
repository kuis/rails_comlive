class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app
  before_action :set_commodity_reference

  def new
    @image = Image.new
  end

  def create
    images = image_params[:url].split(",").map{|u| { url: u } }
    @commodity_reference.images.create(images)
    redirect_to @commodity_reference.commodity, notice: "Images successfully created"
  end

  private

  def set_app
    @app = App.find(params[:app_id])
  end

  def set_commodity_reference
    @commodity_reference = @app.commodity_references.find(params[:commodity_reference_id])
  end

  def image_params
    params.require(:image).permit(:url)
  end
end
