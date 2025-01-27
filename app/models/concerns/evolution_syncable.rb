module EvolutionSyncable
  extend ActiveSupport::Concern

  def evolution_api_instance?
    return false unless api?
    return false unless channel&.webhook_url.present?
    
    # Verifica se o webhook_url é da Evolution API
    webhook_host = URI.parse(channel.webhook_url).host rescue nil
    evolution_host = URI.parse(EVOLUTION_API_CONFIG[:url]).host rescue nil
    
    Rails.logger.info "Evolution API - Webhook URL: #{channel.webhook_url}"
    Rails.logger.info "Evolution API - Webhook host: #{webhook_host}"
    Rails.logger.info "Evolution API - Evolution host: #{evolution_host}"
    
    webhook_host == evolution_host && channel.webhook_url.include?('/chatwoot/webhook/')
  end

  def extract_evolution_instance_name
    return unless evolution_api_instance?
    webhook_path = channel.webhook_url.split('/chatwoot/webhook/').last
    Rails.logger.info "Evolution API - Nome da instância extraído: #{webhook_path}"
    webhook_path if webhook_path.present?
  end

  def delete_evolution_instance
    return unless evolution_api_instance?

    instance_name = extract_evolution_instance_name
    return if instance_name.blank?

    uri = URI.parse("#{EVOLUTION_API_CONFIG[:url]}/instance/delete/#{instance_name}")
    Rails.logger.info "Evolution API - Tentando excluir instância: #{instance_name}"
    Rails.logger.info "Evolution API - URL completa: #{uri}"

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri)
    request['apikey'] = EVOLUTION_API_CONFIG[:api_key]
    request['Content-Type'] = 'application/json'
    
    response = http.request(request)
    Rails.logger.info "Evolution API response for deleting instance #{instance_name}: #{response.code} - #{response.body}"
  end
end 