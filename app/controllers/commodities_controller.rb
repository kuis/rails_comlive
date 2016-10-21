class CommoditiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :autocomplete, :prefetch]
  after_action :record_recent_commodity, only: :show

  def index
    if params[:q]
      if params[:q].empty?
        recently_visited =  cookies[:recent_commodities].nil? ? [] : cookies[:recent_commodities].split(",")
        saved_commodiites = current_user.list.commodities
        ids = recently_visited + saved_commodiites
        @commodities = Commodity.where(id: ids.uniq).page(params[:page])
      else
        @commodities = Commodity.search params[:q], page: params[:page], per_page: 10
      end
      render json: response_for(@commodities)
    elsif params[:query]
      @commodities = Commodity.search(params[:query], operator: "or", match: :word_start,
                                      fields: ["name^10", "short_description", "long_description"]).records.recent.page(params[:page]).per_page(10)
    else
      @recent_commodities = Commodity.recent.limit(5)
    end
  end

  def show
    if user_signed_in?
      @commodity = Commodity.find_by(id: params[:id])
      @commodity = Commodity.find_by(uuid: params[:uuid]) if params[:uuid]
      @com_ref = CommodityReference.find_by(app_id: current_app.id, commodity_id: @commodity.id)
      @com_ref = @commodity.create_reference(current_user) if @com_ref.nil?
    else
      @commodity = Commodity.find_by(uuid: params[:uuid])
      authenticate_user! if params[:id]
      return if @commodity.nil?
    end
    @brand = @commodity.brand
    @specifications = policy_scope(@commodity.specifications)
    @packagings = policy_scope(@commodity.packagings)
    @standards = @commodity.standards # policy_scope(@commodity.standards)
    @references = policy_scope(@commodity.references)
    @links = policy_scope(@commodity.links)
    @state = @commodity.state(current_app)
    @barcodes = @commodity.barcodes # policy_scope(@commodity.barcodes)
    @com_source_references = Reference.where(source_commodity_id: @commodity.id)
  end

  def new
    @commodity = Commodity.new
    @brand = Brand.find(params[:brand_id]) if params[:brand_id]
  end

  def create
    @commodity = Commodity.create(commodity_params)
    if @commodity.save
      @commodity.create_reference(current_user)
      redirect_to @commodity, notice: t("commodities.messages.created")
    else
      render :new
    end
  end

  def edit
    @commodity = Commodity.find(params[:id])
  end

  def update
    @commodity = Commodity.find(params[:id])
    if @commodity.update(commodity_params)
      redirect_to @commodity, notice: t("commodities.messages.updated")
    else
      render :edit
    end
  end

  def autocomplete
    @commodities =  Commodity.search(params[:query], limit: 10)
    response = @commodities.each_with_object([]) do |commodity,arr|
      arr << { id: commodity.id, name: commodity.name, href: commodity_url(commodity) }
    end
    render json: response.to_json
  end

  def prefetch
    @commodities =  Commodity.page(params[:page])
    response = @commodities.each_with_object([]) do |commodity,arr|
      arr << { id: commodity.id, name: commodity.name, href: commodity_url(commodity) }
    end
    render json: response
  end

  private

  def response_for(commodities)
    response = {}
    response[:total_count]  = @commodities.total_entries
    response[:current_page] = @commodities.current_page.to_i
    response[:last_page]    = @commodities.total_pages == @commodities.current_page
    response[:items]        = []
    commodities.each {|c| response[:items] << c }
    return response
  end

  def record_recent_commodity
    return unless params[:id]
    commodities = cookies.permanent[:recent_commodities] || []
    commodity_id = params[:id]
    if commodities.empty?
      commodities << commodity_id
    else
      commodities = cookies.permanent[:recent_commodities].split(",")
      commodities.delete(commodity_id) if commodities.include?(commodity_id)
      commodities.unshift(commodity_id)
      commodities.pop if commodities.size > 5
    end
    cookies.permanent[:recent_commodities] = commodities.join(",")
  end

  def commodity_params
    params.require(:commodity).permit(:name, :short_description, :long_description, :generic, :brand_id, :measured_in,
                                      :hscode_section_id, :hscode_chapter_id, :hscode_heading_id, :hscode_subheading_id,
                                      :unspsc_commodity_id, :visibility)
  end
end
