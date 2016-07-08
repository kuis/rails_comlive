module BrandsHelper
  def options_for_brands(user)
    user.apps.each_with_object([]) do |app, arr|
      app.brands.official.each do |brand|
        arr << [brand.name, "Brand-#{brand.id}"]
      end
    end
  end
end
