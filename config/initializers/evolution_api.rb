# frozen_string_literal: true

Rails.application.config.after_initialize do
  EVOLUTION_API_CONFIG = {
    url: ENV.fetch('EVOLUTION_API_URL', 'http://192.168.15.4:8080'),
    api_key: ENV.fetch('EVOLUTION_API_KEY', '1f31f46873429a0527b7f148c924b35f3118e8e7ee3a4aa3cf51b7eaa066ac0820f52070299f303beef3e3d693685906197129e9a3bdb39970fbc0e6764fd133')
  }.freeze
end 