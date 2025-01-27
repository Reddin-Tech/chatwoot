# == Schema Information
#
# Table name: channel_evolutions
#
#  id              :bigint           not null, primary key
#  instance_name   :string           not null
#  phone_number    :string
#  provider        :string           default("evolution")
#  provider_config :jsonb
#  webhook_url     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :integer          not null
#
# Indexes
#
#  index_channel_evolutions_on_account_id     (account_id)
#  index_channel_evolutions_on_instance_name  (instance_name) UNIQUE
#
class Channel::Evolution < ApplicationRecord
  include Channelable

  self.table_name = 'channel_evolutions'
  EDITABLE_ATTRS = [:webhook_url].freeze

  validates :account_id, presence: true
  validates :instance_name, presence: true, uniqueness: true

  belongs_to :account
  has_one :inbox, as: :channel, dependent: :destroy

  before_destroy :delete_evolution_instance
  after_save :update_instance_name_from_webhook, if: :webhook_url_changed?

  def name
    'Evolution'
  end

  def has_24_hour_messaging_window?
    false
  end

  def messaging_window_enabled?
    false
  end

  private

  def update_instance_name_from_webhook
    return unless webhook_url.present?
    
    # Extrai o nome da instância da URL do webhook (última parte após a última /)
    instance_name_from_webhook = webhook_url.split('/').last
    
    # Atualiza o instance_name do canal
    update_column(:instance_name, instance_name_from_webhook)
    
    # Atualiza o nome da caixa
    inbox&.update_column(:name, instance_name_from_webhook)
  end

  def delete_evolution_instance
    Rails.logger.info("=== Iniciando deleção da instância Evolution ===")
    Rails.logger.info("Instance Name: #{instance_name}")
    Rails.logger.info("Inbox Name: #{inbox&.name}")

    begin
      controller = Api::V1::Accounts::Inboxes::EvolutionController.new
      
      # Primeiro tenta com o nome da instância do canal
      result = controller.delete_instance(instance_name)
      
      if result
        Rails.logger.info("Instância Evolution deletada com sucesso usando nome da instância: #{instance_name}")
      else
        Rails.logger.error("Falha ao deletar instância Evolution com nome da instância: #{instance_name}")
        
        # Se falhar, tenta com o nome da caixa de entrada
        if inbox&.name.present?
          # Remove caracteres especiais e espaços do nome da caixa
          sanitized_name = inbox.name.parameterize
          # Adiciona o prefixo SC e o ID da conta como na criação
          formatted_name = "#{sanitized_name}_SC#{account.id}_"
          
          Rails.logger.info("Tentando deletar com nome formatado: #{formatted_name}")
          
          # Tenta deletar usando o nome formatado como prefixo
          result = controller.delete_instance(formatted_name)
          
          if result
            Rails.logger.info("Instância Evolution deletada com sucesso usando nome formatado: #{formatted_name}")
          else
            Rails.logger.error("Falha ao deletar instância Evolution com nome formatado: #{formatted_name}")
          end
        else
          Rails.logger.error("Nome da caixa não encontrado para tentar deleção alternativa")
        end
      end
    rescue StandardError => e
      Rails.logger.error("Erro ao deletar instância Evolution: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
    end

    # Não interrompe a deleção do canal mesmo se falhar a deleção da instância
    true
  end
end 
