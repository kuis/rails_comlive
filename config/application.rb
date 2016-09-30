require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommodityLive
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # autoload lib files
    config.autoload_paths << Rails.root.join('lib')

    # available languages
    I18n.available_locales = [:en, :nb]

    # default localse
    config.i18n.default_locale = :en
  end
end
