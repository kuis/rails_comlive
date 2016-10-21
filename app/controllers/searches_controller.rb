class SearchesController < ApplicationController
  def index
    query = Searchkick.search params[:query], index_name: [Commodity, Brand, Standard],
                              operator: "or" #, includes_at: { standard: [:brand] }
    @meta = query.response
    @results = query.results.paginate(:page => params[:page], :per_page => 15)
  end
end
