module Api
  module V1
    module Accounts
      module Inboxes
        class EvolutionController < ApplicationController
          include DeviseTokenAuth::Concerns::SetUserByToken
          respond_to :json
          
          before_action :authenticate_user!
          before_action :set_account
          before_action :validate_evolution_params, only: [:create]
          protect_from_forgery with: :null_session

          EVOLUTION_API_URL = "http://192.168.15.4:8080"
          CHATWOOT_URL = "http://192.168.15.4:3000"

          def create
            Rails.logger.info("=== Detalhes da Requisição Create ===")
            Rails.logger.info("Current User: #{current_user.inspect}")
            Rails.logger.info("Current Account: #{@account.inspect}")
            Rails.logger.info("Parâmetros: #{params.inspect}")
            Rails.logger.info("=== Fim dos Detalhes da Requisição ===")

            # Gera um nome único para a instância
            instance_name = generate_instance_name(evolution_params[:name])

            # Prepara os dados para a Evolution API
            evolution_data = {
              instanceName: instance_name,
              integration: "WHATSAPP-BAILEYS",
              webhook: {
                url: CHATWOOT_URL,
                enabled: false,
                events: [
                  "QRCODE_UPDATED",
                  "CONNECTION_UPDATE",
                  "MESSAGES_SET",
                  "MESSAGES_UPSERT",
                  "MESSAGES_UPDATE",
                  "SEND_MESSAGE",
                  "CONTACTS_SET",
                  "CONTACTS_UPSERT",
                  "CONTACTS_UPDATE",
                  "PRESENCE_UPDATE",
                  "CHATS_SET",
                  "CHATS_UPSERT",
                  "CHATS_UPDATE",
                  "CHATS_DELETE",
                  "GROUPS_UPSERT",
                  "GROUP_UPDATE",
                  "GROUP_PARTICIPANTS_UPDATE",
                  "CONNECTION_STATE"
                ]
              },
              settings: {
                reject_call: false,
                msg_call: "",
                groups_ignore: false,
                always_online: false,
                read_messages: false,
                read_status: false
              },
              chatwootAccountId: @account.id.to_s,
              chatwootToken: current_user.access_token&.token,
              chatwootUrl: CHATWOOT_URL,
              chatwootSignMsg: false,
              chatwootSignDelimiter: "\\n",
              chatwootNameInbox: evolution_params[:name],
              chatwootAutoCreate: true,
              chatwootOrganization: "",
              chatwootLogo: "",
              chatwootReopenConversation: true,
              chatwootConversationPending: false,
              chatwootMergeBrazilContacts: false,
              chatwootImportContacts: false,
              chatwootImportMessages: false,
              chatwootDaysLimitImportMessages: 5,
              chatwootIgnoreJids: [],
              typebot: {
                enabled: false,
                url: "",
                workspace_id: "",
                bot_id: "",
                expire_time: 60
              },
              rabbitmq: {
                enabled: false,
                host: "",
                queue_name: ""
              },
              websocket: {
                enabled: true,
                events: [
                  "QRCODE_UPDATED",
                  "CONNECTION_UPDATE",
                  "MESSAGES_SET",
                  "MESSAGES_UPSERT",
                  "MESSAGES_UPDATE",
                  "SEND_MESSAGE"
                ]
              }
            }

            # Log para debug
            Rails.logger.info("Enviando requisição para Evolution API:")
            Rails.logger.info("URL: #{EVOLUTION_API_URL}/instance/create")
            Rails.logger.info("Headers: #{{'Content-Type': 'application/json', 'apikey': ENV.fetch('API_ACCESS_TOKEN')}.inspect}")
            Rails.logger.info("Body: #{evolution_data.to_json}")

            # Chama a Evolution API
            response = HTTParty.post(
              "#{EVOLUTION_API_URL}/instance/create",
              body: evolution_data.to_json,
              headers: {
                'Content-Type': 'application/json',
                'apikey': ENV.fetch('API_ACCESS_TOKEN')
              }
            )

            # Log da resposta para debug
            Rails.logger.info("Resposta da Evolution API:")
            Rails.logger.info("Status: #{response.code}")
            Rails.logger.info("Body: #{response.body}")

            unless response.success?
              Rails.logger.error("Erro na API Evolution: #{response.body}")
              error_message = response.parsed_response['response']['message'] || 'Erro desconhecido'
              render json: { success: false, error: "Erro ao criar instância: #{error_message}" }, status: :unprocessable_entity
              return
            end

            render json: { 
              success: true, 
              message: 'Instância sendo criada. Aguarde a criação automática da caixa.'
            }
          rescue StandardError => e
            Rails.logger.error("Erro ao criar instância: #{e.message}")
            Rails.logger.error(e.backtrace.join("\n"))
            render json: { success: false, error: "Erro interno ao criar instância: #{e.message}" }, status: :internal_server_error
          end

          def delete_instance(instance_name)
            Rails.logger.info("=== Deletando Instância Evolution ===")
            Rails.logger.info("Instance Name: #{instance_name}")

            response = HTTParty.delete(
              "#{EVOLUTION_API_URL}/instance/delete/#{instance_name}",
              headers: {
                'Content-Type': 'application/json',
                'apikey': ENV.fetch('API_ACCESS_TOKEN')
              }
            )

            Rails.logger.info("Resposta da Evolution API (Delete):")
            Rails.logger.info("Status: #{response.code}")
            Rails.logger.info("Body: #{response.body}")

            response.success?
          rescue StandardError => e
            Rails.logger.error("Erro ao deletar instância Evolution: #{e.message}")
            false
          end

          def check_inbox
            # Procura por qualquer caixa Evolution criada recentemente para esta conta
            Rails.logger.info("=== Verificando Caixa Evolution ===")
            Rails.logger.info("Account ID: #{@account.id}")
            
            inbox = @account.inboxes
                          .where("channel_type IN (?)", ['Channel::Evolution', 'Channel::Api', 'api'])
                          .order(created_at: :desc)
                          .first

            Rails.logger.info("Caixa encontrada: #{inbox.inspect}")
            Rails.logger.info("ID da caixa: #{inbox&.id}")
            Rails.logger.info("Nome da caixa: #{inbox&.name}")
            Rails.logger.info("Tipo do canal: #{inbox&.channel_type}")
            Rails.logger.info("=== Fim da Verificação ===")

            if inbox.present?
              render json: { 
                success: true, 
                inbox_id: inbox.id,
                inbox_name: inbox.name,
                channel_type: inbox.channel_type
              }
            else
              render json: { success: false }
            end
          end

          private

          def generate_instance_name(base_name)
            # Remove caracteres especiais e espaços
            sanitized_name = base_name.parameterize
            # Adiciona o prefixo SC (SimpleJus Chatwoot) e o ID da conta
            "#{sanitized_name}_SC#{@account.id}_#{SecureRandom.hex(4)}"
          end

          def set_account
            Rails.logger.info("=== Detalhes do Set Account ===")
            Rails.logger.info("Account ID: #{params[:account_id]}")
            @account = Account.find(params[:account_id])
            Rails.logger.info("Account encontrada: #{@account.inspect}")
            Rails.logger.info("=== Fim dos Detalhes do Set Account ===")
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error("Conta não encontrada: #{e.message}")
            render json: { error: 'Conta não encontrada' }, status: :not_found
          end

          def evolution_params
            params.permit(:name)
          end

          def validate_evolution_params
            unless evolution_params[:name].present?
              render json: { error: 'Nome é obrigatório' }, status: :unprocessable_entity
              return
            end

            # Verifica se já existe uma caixa de entrada com o mesmo nome na mesma conta
            existing_inbox = @account.inboxes
                                   .where(name: evolution_params[:name])
                                   .exists?

            if existing_inbox
              render json: { error: 'Já existe uma caixa de entrada com este nome nesta conta' }, status: :unprocessable_entity
              return
            end
          end

          def validate_environment_variables!
            required_vars = %w[API_ACCESS_TOKEN]
            missing_vars = required_vars.select { |var| ENV[var].blank? }
            
            if missing_vars.any?
              Rails.logger.error("Variáveis de ambiente faltando: #{missing_vars.join(', ')}")
              raise "Configuração incompleta. Faltam variáveis de ambiente: #{missing_vars.join(', ')}"
            end
          end
        end
      end
    end
  end
end 