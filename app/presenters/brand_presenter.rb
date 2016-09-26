class BrandPresenter < BasePresenter
  def url
    @model.url ? @model.url : "#"
  end

  def phone
    @model.phone ? "tel:#{@model.phone}" : "#"
  end

  def email
    @model.email ? "mailto:#{@model.email}" : "#"
  end

  def skype
    @model.skype_username ? "skype:#{@model.skype_username}?chat" :  "#"
  end

  def facebook
    @model.facebook_address ? @model.facebook_address : "#"
  end

  def twitter
    @model.twitter_handle ? "https://twitter.com/#{@model.twitter_handle}" : "#"
  end

  def open_corp_url
    @model.open_corporate_url ?  @model.open_corporate_url : "#"
  end

  def wipo_url
    @model.wipo_url ? @model.wipo_url : "#"
  end
end
