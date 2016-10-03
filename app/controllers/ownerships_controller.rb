class OwnershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child, only: :new
  before_action :set_parent, only: :create

  def new
    @ownership = Ownership.new(child: @child)
  end

  def create
    @ownership = @parent.ownerships.create(ownership_params.except(:parent_id))
    if @ownership.save
      NotificationMailer.claim(@ownership).deliver
      redirect_to @ownership.child, notice: t("ownerships.messages.created")
    else
      @child = @ownership.child
      render :new
    end
  end

  private

  def set_child
    @child = params[:child_type].classify.constantize.find(params[:child_id])
  end

  def set_parent
    parent_type, parent_id = ownership_params[:parent_id].split("-")
    @parent = parent_type.classify.constantize.find(parent_id)
  end

  def ownership_params
    params.require(:ownership).permit(:parent_id, :child_id, :child_type)
  end
end
