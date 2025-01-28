# frozen_string_literal: true

Rails.application.config.after_initialize do
  EVOLUTION_API_CONFIG = {
    url: ENV.fetch('EVOLUTION_API_URL'),
    api_key: ENV.fetch('EVOLUTION_API_KEY')
  }.freeze
end 