class UnspscClassDatatable
  delegate :params, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: UnspscClass.count,
        iTotalDisplayRecords: classes.total_entries,
        aaData: data
    }
  end

  private

  def data
    classes.map do |uclass|
      [
          uclass.code,
          uclass.long_code,
          uclass.description,
          link_to("View", "javascript:void(0)", class: "unspsc-drilldown", data: { href: filter_url(uclass), type: "Commodities" } )
      ]
    end
  end

  def classes
    @classes ||= fetch_classes
  end

  def fetch_classes
    classes = unspsc_classes.order("#{sort_column} #{sort_direction}")
    classes = classes.page(page).per_page(per_page)
    if params[:sSearch].present?
      classes = classes.where("code like :search or long_code iLike :search or description iLike :search", search: "%#{params[:sSearch]}%")
    end
    classes
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 30
  end

  def sort_column
    columns = %w[code long_code description]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def unspsc_classes
    UnspscFamily.find(params[:unspsc_family_id]).unspsc_classes
  end

  def filter_url(uclass)
    Rails.application.routes.url_helpers.unspsc_commodities_path(format: "json", unspsc_class_id: uclass.id)
  end
end