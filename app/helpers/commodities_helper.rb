module CommoditiesHelper
  def options_for_hscode_sections
    HscodeSection.all.map{|hs| [hs.description, hs.id]}
  end
end
