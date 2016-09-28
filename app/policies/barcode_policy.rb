class BarcodePolicy < ApplicationPolicy
  attr_reader :user, :barcode

  def initialize(user, barcode)
    @user     = user
    @barcode  = barcode
  end

  def show?
    visible?
  end

  def edit?
    visible?
  end

  class Scope < Scope
    def resolve
      return scope.where(visibility: "publicized") if user.nil?
      scope.all
    end
  end

  private

  def visible?
    barcode.visibility_status == "Public"
  end
end
