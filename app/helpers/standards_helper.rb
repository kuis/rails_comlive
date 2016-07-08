module StandardsHelper
  def options_for_standards(user)
    user.apps.each_with_object([]) do |app, arr|
      app.standards.official.each do |standard|
        arr << [standard.name, "Standard-#{standard.id}"]
      end
    end
  end
end
