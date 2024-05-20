# config/initializers/stripe.rb
Rails.configuration.stripe = {
    publishable_key: Rails.application.config.stripe[:publishable_key],
    secret_key: Rails.application.config.stripe[:secret_key]
  }
  
  Stripe.api_key = Rails.configuration.stripe[:secret_key]
  