class SearchesController < ApplicationController
  def index
    query = Searchkick.search params[:query], index_name: [Commodity, Brand, Standard], operator: "or"
    @meta = query.response
    @results = query.results
    respond_to do |format|
      format.json { render json: search_results(@results) }
      format.html
    end

  end

  private

  def model_url(model)
    case model
      when Commodity
        commodity_url(model)
      when Brand
        brand_url(model)
      when Standard
        brand_standard_url(model.brand, model)
    end
  end

  def search_results(results)
    results.each_with_object([]) do |model,arr|
      arr << { id: model.id, name: "#{model.class.to_s} > #{model.name}", href: model_url(model)  }
    end
  end
end
