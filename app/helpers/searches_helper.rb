module SearchesHelper
  def search_url_for(result)
    case result
      when Standard
        [result.brand, result]
      else
        [result]
    end
  end

  def search_description(result)
    case result
      when Commodity
        result.short_description
      else
        result.description
    end
  end
end
