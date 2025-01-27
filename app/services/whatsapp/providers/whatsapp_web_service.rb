module Whatsapp::Providers
  class WhatsappWebService < Whatsapp::Providers::BaseService
    def send_message(phone_number, message)
      nil
    end

    def send_template(phone_number, template_info)
      nil
    end

    def sync_templates
      whatsapp_channel.mark_message_templates_updated
    end

    def validate_provider_config?
      true
    end

    def api_headers
      { 'Content-Type' => 'application/json' }
    end

    private

    def send_text_message(phone_number, message)
      nil
    end

    def send_attachment_message(phone_number, message)
      nil
    end

    def send_interactive_text_message(phone_number, message)
      nil
    end
  end
end 