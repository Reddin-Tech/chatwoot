# frozen_string_literal: true

# Sobrescreve métodos do ChatwootHub para sempre retornar enterprise
module ChatwootHub
  class << self
    def pricing_plan
      'enterprise'
    end

    def pricing_plan_quantity
      999999
    end

    def billing_url
      '#'
    end

    def installation_identifier
      'enterprise-instance'
    end

    # Mantém a configuração original do support_config
    def support_config
      {
        support_website_token: nil,
        support_script_url: nil,
        support_identifier_hash: nil
      }
    end

    # Desabilita todas as chamadas externas
    def sync_with_hub
      nil
    end

    def register_instance(*_args)
      nil
    end

    def send_push(*_args)
      nil
    end

    def emit_event(*_args)
      nil
    end

    def get_captain_settings(*_args)
      nil
    end

    def instance_config
      {
        installation_identifier: installation_identifier,
        installation_version: '0.0.0',
        installation_host: 'localhost',
        installation_env: 'production',
        edition: 'enterprise'
      }
    end

    def instance_metrics
      {
        accounts_count: 0,
        users_count: 0,
        inboxes_count: 0,
        conversations_count: 0,
        incoming_messages_count: 0,
        outgoing_messages_count: 0,
        additional_information: {}
      }
    end
  end
end 