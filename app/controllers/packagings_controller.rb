class PackagingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_app
  before_action :set_commodity_reference

  after_action :verify_authorized, except: :index

  def index
    if @app.present?
      @packagings = @commodity_reference.packagings.page(params[:page])
    else
      @packagings = Packaging.page(params[:page])
    end
  end

  def new
    authorize @app, :show?
    @packaging = Packaging.new
    render layout: !request.xhr?
  end

  def create
    authorize @app, :show?
    @packaging = @commodity_reference.packagings.create(packaging_params)
    if @packaging.save
      redirect_to @commodity_reference.commodity, notice: "Packaging successfully saved"
    else
      render :new
    end
  end

  def show
    if @app.present?
      authorize @app
      @packaging = @commodity_reference.packagings.find(params[:id])
      add_breadcrumb "Packagings", packagings_path
      add_breadcrumb @packaging.name, "#"
    else
      skip_authorization
      @packaging = Packaging.find_by(uuid: params[:uuid])
      add_breadcrumb "Packagings", packagings_path
      add_breadcrumb @packaging.name, "#"
    end
  end

  def edit
    authorize @app
    @packaging = @commodity_reference.packagings.find(params[:id])
  end

  def update
    authorize @app
    @packaging = @commodity_reference.packagings.find(params[:id])
    if @packaging.update(packaging_params)
      redirect_to  @commodity_reference.commodity, notice: "Packaging successfully updated"
    else
      render :edit
    end
  end

  private

  def set_app
    return unless params[:app_id]
    @app = App.find(params[:app_id])
  end

  def set_commodity_reference
    return unless params[:app_id]
    @commodity_reference = @app.commodity_references.find(params[:commodity_reference_id])
  end

  def packaging_params
    params.require(:packaging).permit(:name, :description, :uom, :quantity, :visibility)
  end
end
