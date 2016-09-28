class StandardsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  add_breadcrumb "Standards", :standards_path

  def index
    if params[:q]
      @standards = Standard.search params[:q], page: params[:page], per_page: 10
      render json: response_for(@standards)
    else
      @standards = Standard.all
    end
  end

  def new
    @standard = Standard.new

    add_breadcrumb "New", new_standard_path
  end

  def show
    if user_signed_in?
      @standard = Standard.where("id = ? or uuid =? ", params[:id], params[:uuid]).first
    else
      authenticate_user! if params[:id]
      @standard = Standard.find_by(uuid: params[:uuid])
    end
    add_breadcrumb @standard.name, @standard
  end

  def create
    @standard = Standard.create(standard_params)
    if @standard.save
      redirect_to [@app,@standard], notice: "Standard successfully created"
    else
      render :new
    end
  end

  def edit
    @standard = Standard.find(params[:id])

    add_breadcrumb @standard.name, @standard
    add_breadcrumb "Edit", edit_standard_path(@standard)
  end

  def update
    @standard = Standard.find(params[:id])
    if @standard.update(standard_params)
      redirect_to [@app,@standard], notice: "Standard successfully updated"
    else
      render :edit
    end
  end

  private

  def standard_params
    params.require(:standard).permit(:name, :description, :logo)
  end


  def response_for(standards)
    response = {}
    response[:total_count]  = standards.total_entries
    response[:current_page] = standards.current_page.to_i
    response[:last_page]    = standards.total_pages == standards.current_page
    response[:items]        = []
    standards.each {|c| response[:items] << c }
    return response
  end
end
