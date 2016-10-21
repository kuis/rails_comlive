class BasePresenter < SimpleDelegator
  attr_reader :view

  def initialize(model,view)
    @model = model
    @view  = view
    super(@model)
  end
end
