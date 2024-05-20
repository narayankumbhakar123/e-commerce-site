require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ECommerceSite
  class Application < Rails::Application
    config.hosts = nil
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.serve_static_assets = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.stripe = {
      publishable_key: 'pk_test_51JQQXNSDPU1XvvXxPhnKa30JVCLLlBSkQ49qxrQ5LWY8qNuy1kEHX77oOs7awuYrMDfjozdRSkjyzOo2sUrXnd7w00DN427BK0',
      secret_key: 'sk_test_51JQQXNSDPU1XvvXx3ViAdKJjdn7bBGZKVWQLWdierdWSSqZDiUDP7JnLk0c7WifGIY5Fzd80vcawUevORdbzpB4Q004pduPapK'
    }
  end
end
