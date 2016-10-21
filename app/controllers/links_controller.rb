class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app
  before_action :set_commodity_reference

  after_action :verify_authorized

  def new
    authorize @app, :show?
    @link = Link.new
  end

  def create
    authorize @app, :show?
    @link = @app.links.new(link_params)
    @link.commodity_reference_id = @commodity_reference.id
    if @link.save
      redirect_to @link.commodity_reference.commodity, notice: "link successfully created"
    else
      render :new
    end
  end

  def edit
    authorize @app
    @link = @app.links.find(params[:id])
  end

  def update
    authorize @app
    @link = @app.links.find(params[:id])
    if @link.update(link_params)
      redirect_to @link.commodity_reference.commodity, notice: "link successfully updated"
    else
      render :edit
    end
  end

  private

  def set_app
    @app = App.find(params[:app_id])
  end

  def set_commodity_reference
    @commodity_reference = @app.commodity_references.find(params[:commodity_reference_id])
  end

  def link_params
    params.require(:link).permit(:url,:description,:visibility)
  end
end
