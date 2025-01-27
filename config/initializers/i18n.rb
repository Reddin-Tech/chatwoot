# frozen_string_literal: true

# Load translations from all available paths
Rails.application.config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

# Configure available locales
I18n.available_locales = [:en, :pt_BR]

# Set default locale to pt_BR
I18n.default_locale = :pt_BR

# Configure fallback to use English translations when pt_BR is missing
Rails.application.config.i18n.fallbacks = [:en] 