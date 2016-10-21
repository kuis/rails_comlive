class BrandsController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show, :autocomplete]

  def index
    @brands = Brand.all
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.create(brand_params)
    if @brand.save
      redirect_to @brand, notice: t("brands.messages.created")
    else
      render :new
    end
  end

  def show
    if user_signed_in?
      brand = Brand.find_by(id: params[:id])
      @standardization = Standardization.new
    else
      brand = Brand.find_by(uuid: params[:uuid])
      authenticate_user! if params[:id]
      return if brand.nil?
    end

    @brand = BrandPresenter.new(brand, view_context)
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update(brand_params)
      redirect_to @brand, notice: t("brands.messages.updated")
    else
      render :edit
    end
  end

  def autocomplete
    @brands =  Brand.search(params[:query], limit: 10)
    response = @brands.each_with_object([]) do |brand,arr|
      arr << { id: brand.id, name: brand.name, href: brand_url(brand) }
    end
    render json: response.to_json
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :logo, :description, :phone, :location, :email, :url,:skype_username,
                                  :facebook_address, :twitter_handle,:open_corporate_url, :wipo_url)
  end
end
