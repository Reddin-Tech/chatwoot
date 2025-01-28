# Logs de Alterações

## 23/01/2024
- Corrigido problema com pnpm no container Docker - Ajustado PATH no Dockerfile para ambos os estágios de build
- Adicionado serviço Vite no docker-compose.test.yaml para suporte a hot reload em desenvolvimento
- Corrigido erro de inicialização do Rails adicionando a definição do módulo SuperAdmin no arquivo override_account_features.rb
- Corrigido erro com Devise removendo módulo SuperAdmin vazio e usando namespace correto
- Movido código do helper de features para o local correto em app/helpers/super_admin/account_features_helper.rb
- Corrigido formato das features enterprise para combinar corretamente com features base
- Compilado SDK em modo biblioteca para corrigir erro 404 no carregamento do widget
- Adicionado método billing_url ao ChatwootHub para corrigir erro na página de configurações
- Ajustado helper de features para exibir corretamente no formulário de edição de contas
- Ajustado o helper AccountFeaturesHelper para carregar corretamente features premium e enterprise, combinando features base premium com features enterprise
- Ajustado módulo Featurable para incluir features enterprise junto com features base
- Corrigido interpretação da variável DISABLE_ENTERPRISE para habilitar corretamente o modo enterprise
- Ajustado helper e módulo Featurable para respeitar a verificação do modo enterprise antes de carregar features enterprise
- Migração do channel_evolution executada com sucesso usando docker compose -f docker-compose.test.yaml
- Corrigido hardcoding de locale pt-BR na página de configurações do super admin e restaurado funcionalidades de plano e suporte
- Corrigido bug em `account_features_helper.rb` para manter estrutura original dos dados YAML e compatibilidade com código existente
- Corrigido bug no método ensure_valid_name em app/models/inbox.rb para evitar erro de nil quando channel não está presente

## Remoção da validação de licença
- Removido job de verificação periódica `internal_check_new_versions_job` do `schedule.yml`
- Adicionadas configurações no `.env` para:
  - Desabilitar telemetria e comunicação com hub
  - Forçar plano enterprise
  - Definir quantidade ilimitada de licenças
  - Desabilitar URL do hub

**#importante**
- Sistema usa pnpm como gerenciador de pacotes Node.js
- Vite é usado para compilação de assets no ambiente de desenvolvimento
- Configuração do Docker em dois estágios (pre-builder e final)
- Em desenvolvimento, Vite roda como serviço separado na porta 3036 para hot reload 
- Sistema configurado para funcionar sem validação de licença e com recursos enterprise habilitados permanentemente 
- Features enterprise são carregadas e combinadas com features base no módulo Featurable
- Variável DISABLE_ENTERPRISE deve ser "false" (string) para habilitar o modo enterprise
- Features enterprise só são carregadas após verificação do ChatwootApp.enterprise? 
- Removido job de verificação de versões (check_new_versions_job)
- Removida validação de quantidade de licenças da view de configurações
- Desabilitadas todas as chamadas externas ao ChatwootHub
- Sobrescrito métodos do ChatwootHub para retornar valores padrão
- Todas as validações e comunicações com o ChatwootHub foram removidas ou desabilitadas 
- Removido alerta de configuração não autorizada da view de configurações
- Removido botão de refresh de plano
- Removida seção duplicada de "Current plan"
- Removido botão "Upgrade now" das features
- Removidas referências ao plano community
- Traduzidos textos para português na view de configurações

**#importante**
- Interface de configurações simplificada e sem referências a planos ou upgrades 
- Removida task de geração de identificador de instalação
- Simplificado método installation_identifier para retornar valor fixo
- Removidas configurações de suporte do ChatwootHub

**#importante**
- Identificador de instalação simplificado para valor fixo 'enterprise-instance' 
- Removida exibição do identificador da instalação da view de configurações
- Traduzido texto de descrição da página de configurações

**#importante**
- Interface de configurações ainda mais simplificada, sem exibição de identificadores técnicos 
- Removida seção de suporte da página de configurações do super admin

**#importante**
- Interface de configurações focada apenas na exibição e configuração de features

## Configurações de Idioma e Conta
- Alterado `config/installation_config.yml`: ENABLE_ACCOUNT_SIGNUP=false e CREATE_NEW_ACCOUNT_FROM_DASHBOARD=true
- Modificado `app/builders/account_builder.rb`: Forçado locale 'pt_BR' para novas contas
- Alterado `config/initializers/languages.rb`: Removido todos os idiomas exceto pt_BR

#importante
- Sistema configurado para usar exclusivamente pt_BR como idioma
- Criação de contas via signup desabilitada, mas permitida via dashboard
- Novas contas serão criadas automaticamente com locale pt_BR

## Configurações de I18n
- Criado `config/initializers/i18n.rb` para configurar:
  - Locale padrão pt_BR
  - Fallback para en quando traduções pt_BR não existirem
  - Carregamento automático de todas as traduções

#importante
- Sistema usa pt_BR como idioma padrão
- Mantém en como fallback para textos não traduzidos
- Novas features devem ser criadas em pt_BR
- Interface administrativa pode manter textos em inglês onde não houver tradução

# Regras Gerais
- Sistema usa pt_BR como idioma padrão
- Mantém en como fallback para textos não traduzidos
- Novas features devem ser criadas em pt_BR
- Interface administrativa pode manter textos em inglês onde não houver tradução

## Evolution API Integration
- Substituído IPs hardcoded por variáveis de ambiente no Evolution Controller
- Adicionadas variáveis CHATWOOT_URL e EVOLUTION_API_URL no .env
- URLs agora apontam para os serviços via nomes dos containers Docker
- Ajustado o componente WhatsAppWeb.vue para lidar com a resposta do backend
- Alterado o redirecionamento após criar instância para a lista de inboxes
- Corrigida autenticação no frontend para usar tokens do localStorage

# Importante
- The Evolution Controller uses environment variables for URLs of the services
- The URLs of the services should use the names of the containers Docker for internal communication
- The frontend now shows success message and redirects to the list of inboxes after creating instance
- Authentication headers are obtained from localStorage (access-token, client, uid)
- Required tokens: access-token, client, uid and Authorization Bearer
- Token validation before request to avoid 401 errors

## Alterações Evolution API Integration
- Added POST /api/v1/accounts/:account_id/inboxes/evolution route
- Created migration for channel_evolutions table
- Updated Channel::Evolution model
- Updated Evolution controller with authentication and validation
- Added environment variables for configuration:
  - EVOLUTION_API_URL
  - API_ACCESS_TOKEN
  - FRONTEND_URL

#importante
- Evolution API integration requires configuration of the environment variables EVOLUTION_API_URL, API_ACCESS_TOKEN and FRONTEND_URL
- Instance creation is done via POST /api/v1/accounts/:account_id/inboxes/evolution
- The instance name is generated automatically with prefix SC + ID of the account

- Corrigido bug de localização: restaurado suporte a múltiplos idiomas em LANGUAGES_CONFIG and removed hardcoding of pt_BR in account creation

**#importante**
- Sistema agora suporta múltiplos idiomas and respects the user's language preference in account creation

## Alterações Importantes
- Corrigido bug de internacionalização na validação de nomes duplicados de caixas de entrada (inbox.rb)
- Added translation keys for error message of duplicate inbox name in en.yml and pt_BR.yml
- Adicionada validação de nome único para caixas de entrada WhatsApp Web (Evolution) por account - Impede criação de caixas com mesmo nome na mesma conta
- Revertido fluxo de criação para criar caixa imediatamente sem delay - Separada a criação da verificação no backend e frontend
- Ajustada validação de nome único para caixas Evolution para considerar apenas caixas criadas pelo mesmo usuário na mesma conta
- Corrigido processo de deleção da instância Evolution - Agora usa nome original da caixa como fallback

**#importante**
- Deleção da instância Evolution agora tenta com nome exato e depois com nome original da caixa
- Melhorados logs para rastreamento do processo de deleção

## Correção de Esquema do Banco de Dados
- Removed redundant channel_evolution table keeping only channel_evolutions for avoiding duplication and maintaining consistency with Rails conventions
- Table channel_evolutions is the only table for managing Evolution channels, following Rails conventions of plural names
- Executed migration to remove channel_evolution table and updated schema.rb

**#importante**
- Table channel_evolutions is the only table for managing Evolution channels, following Rails conventions of plural names

## Correção de Bug na Autenticação Evolution
- Corrigido bug de autenticação na criação de instâncias Evolution
- Moved API call creation instance from axios directly to InboxesAPI
- Added createEvolutionInstance method in Inboxes class
- Updated createEvolutionInstance action in store to use InboxesAPI

**#importante**
- Evolution instance creation calls now use InboxesAPI with appropriate authentication

## Correção de Problema de Rota Duplicada
- Corrigido problema de rota duplicada para evolution in config/routes.rb, removing redundant accounts/inboxes/evolution route and keeping only inboxes/evolution#create

## Análise do Provedor WhatsApp Padrão
- Mantido 'whatsapp_web' as default provider in Whatsapp.vue
- Interface allows explicit selection of desired provider (Cloud, Web, Twilio, 360dialog)
- There is no negative impact on security or functionality with this configuration
- User retains full control over provider choice

## Correções de Carregamento de Modelos
- Added explicit require_relative for Channel::Evolution in InboxesController to ensure correct model loading

- Criado novo usuário administrador (email: admin@admin.com, senha: Admin@123) com conta associada

**#importante**
- Credenciais do administrador padrão: admin@admin.com / Admin@123

## Alterações Importantes
- Corrigido processo de criação e deleção de caixas Evolution

**#importante**
- Removida criação manual da caixa - agora aguarda criação via webhook da Evolution
- Corrigida deleção da instância - tenta com nome exato e depois com nome formatado
- Melhorada verificação de caixa criada - procura pela última caixa Evolution do usuário

## Ajustes no Processo de Criação de Caixas Evolution
- Melhorada validação de nomes duplicados para considerar todas as caixas da conta
- Reduzido intervalo de polling de 1000ms para 500ms
- Reduzido número máximo de tentativas de verificação de 10 para 5
- Ajustado redirecionamento para ser mais rápido

**#importante**
- Validação de nomes duplicados agora considera todas as caixas da conta
- Polling mais rápido (500ms) para verificar criação da caixa

## Ajustes nas Mensagens de Notificação Evolution
- Removida duplicação de mensagens toast
- Mensagem de sucesso movida para o momento exato da confirmação de criação
- Simplificado fluxo de notificações para mostrar apenas uma mensagem por estado (sucesso/erro)

**#importante**
- Toast de sucesso aparece apenas após confirmação efetiva da criação da caixa
- Evitada duplicação de mensagens durante o processo de criação/redirecionamento

## Melhorias na Deleção e Redirecionamento Evolution
- Reformulada lógica de deleção para usar nome consistente com a criação
- Adicionado formato padronizado nome_SC{account_id}_ para deleção
- Melhorados logs de rastreamento do processo de deleção
- Substituído router.replace por router.push para melhor navegação
- Adicionados delays controlados para garantir exibição de mensagens
- Ajustados intervalos de polling e número de tentativas

**#importante**
- Deleção usa mesmo padrão de nome da criação (nome_SC{account_id}_)
- Navegação mais suave com router.push e delays controlados

**#importante** Corrigido bug nas condicionais de ambiente em db/seeds.rb - Alterado de Rails.env.production? para Rails.env.development? para manter a lógica correta de seeding em desenvolvimento/produção

**#importante** 
- Reorganizado seeds.rb para executar corretamente os seeds de desenvolvimento no ambiente de desenvolvimento
- Movido setup de onboarding para dentro do bloco de desenvolvimento
- Separado claramente seeds de desenvolvimento e produção

- Removida rota duplicada `resources :accounts` em `config/routes.rb` que estava causando conflitos de roteamento na API.

#importante
- Evitar duplicação de rotas para prevenir conflitos e comportamentos inesperados no roteamento da API.

## Análise do Problema com Nomes de Instância Evolution
- Identificado que o nome completo da instância (ex: minhacaixa_SC123_abc123) não está sendo salvo corretamente
- O campo instance_name na tabela channel_evolutions existe mas não está sendo usado adequadamente
- Na criação, o nome completo é gerado mas não é salvo
- Na exclusão, tentamos usar o nome base e depois um formato similar, mas não temos garantia de ser o mesmo nome

**#importante**
- O nome completo da instância Evolution deve ser salvo no campo instance_name da tabela channel_evolutions
- Necessário ajustar o processo de criação para salvar o nome completo gerado

## Descoberta sobre Nome da Instância Evolution
- Identificado que o nome completo da instância está disponível na URL do webhook retornado pela Evolution API
- O nome é gerado no formato: `nome-base_SC{account_id}_{random_hex}`
- Podemos usar esse nome para atualizar o campo instance_name no channel_evolutions

**#importante**
- O nome completo da instância pode ser extraído da URL do webhook retornado pela Evolution API
- Não é necessário salvar o nome no momento da criação, pois ele vem completo no retorno do webhook

## Correção do Nome da Instância Evolution
- Adicionado callback no Channel::Evolution para atualizar nome da instância e da caixa
- O nome completo é extraído da URL do webhook (ex: 1234_SC3_01b030d4)
- O mesmo nome é usado tanto para a caixa quanto para o instance_name do canal

**#importante**
- O nome da caixa e instance_name são atualizados automaticamente quando o webhook_url é definido pela Evolution
- Isso garante consistência entre o nome no Chatwoot e na Evolution API
- A deleção agora sempre usará o nome correto da instância

## Correção do Fluxo de Criação da Caixa Evolution
- Corrigido problema de loading infinito no botão de criar
- Removida dependência do nome da caixa na verificação
- Simplificado fluxo de redirecionamento e verificação
- Adicionado await no redirectToAgentsPage para garantir conclusão

**#importante**
- Verificação da caixa agora usa apenas o accountId para encontrar a última caixa criada
- Fluxo de criação e verificação mais robusto e sem travamentos

## Separação dos Processos de Criação e Verificação Evolution
- Separado processo de criação do processo de verificação
- Criação agora apenas cria e retorna feedback imediato
- Verificação é um processo independente que:
  1. Redireciona para página temporária de agentes
  2. Faz 3 tentativas de verificação (uma a cada 2 segundos)
  3. Se encontrar a caixa, ajusta URL para configuração de agentes
  4. Se não encontrar, redireciona para lista com mensagem

**#importante**
- Processos de criação e verificação agora são independentes
- Feedback imediato após criação
- Verificação tenta 3x a cada 2 segundos encontrar a caixa
- URLs ajustadas para formato correto:
  - Configuração: /app/accounts/{Account id}/settings/inboxes/new/{id caixa}/agents
  - Lista: /app/accounts/{Account id}/settings/inboxes/list

# Logs do Cursor

## Alterações Importantes

- Ajustado fluxo de criação de caixa de entrada:
  - Adicionado campo para nome da caixa
  - Implementado polling para verificar criação
  - Corrigido redirecionamento após criação
  - Adicionados logs para debug
  - Removida verificação incorreta de channel_type

#importante
- Caixas de entrada precisam de nome antes de criar
- Polling verifica 3x a cada 2s se a caixa foi criada
- Após criar, redireciona para configurar agentes ou lista

# Correção de Autenticação na API
- Corrigido problema de autenticação na listagem de caixas
- Ajustada classe InboxesAPI para usar autenticação correta
- Adicionada atualização forçada da lista antes do polling
- Melhorados logs para debug do processo

#importante
- Chamadas à API precisam dos headers: access-token, client e uid
- Lista de caixas é atualizada antes de iniciar polling
- Logs adicionados para rastrear processo de criação e verificação

# Correção de Erro no Build do Vite
- Corrigido erro de build do Vite relacionado a imports incorretos
- Restaurada versão funcional do arquivo inboxes.js usando CacheEnabledApiClient
- Reiniciado container do Rails para limpar cache

#importante
- Manter imports originais do projeto ao fazer alterações
- Usar CacheEnabledApiClient para APIs que precisam de cache
- Reiniciar Rails após alterações em arquivos JS para limpar cache

# Ajustes no Polling de Caixas de Entrada
- Adicionado validateHash: false para forçar atualização da lista de caixas
- Melhorados logs para debug do processo de polling
- Ajustada verificação para encontrar caixas do tipo Channel::Api

#importante
- Polling agora força atualização da lista de caixas a cada tentativa
- Logs mais detalhados para rastrear o processo de criação e polling
- Verificação específica para caixas do tipo API

# Fluxo de Criação de Caixa de Entrada
- POST /api/v1/accounts/{id}/inboxes/evolution cria a instância
- POST /api/v1/accounts/{id}/inboxes/ cria a caixa com webhook
- GET /api/v1/accounts/{id}/inboxes verifica a criação
- Conversa inicial criada automaticamente
- QR Code gerado e enviado na conversa

#importante
- Fluxo sequencial: criar instância > criar caixa > verificar > gerar QR
- Webhook configurado automaticamente na criação
- QR Code disponível na primeira mensagem da conversa

# Correção do Redirecionamento para Página de Agentes
- Ajustado redirecionamento para usar nome da rota ao invés de path
- Rota correta: settings_inboxes_add_agents com parâmetros accountId e inbox_id
- Mantido fluxo sequencial: criar > polling > redirecionar

#importante
- Redirecionamento agora usa nome da rota settings_inboxes_add_agents
- Parâmetros necessários: accountId e inbox_id

# Correção do Polling e Redirecionamento
- Removida dependência do nome da caixa no polling
- Polling agora busca a caixa mais recente do tipo Channel::Api
- Ordenação por data de criação para garantir que encontre a última caixa criada
- Mantido fluxo sequencial e número de tentativas

#importante
- Polling simplificado: busca caixa mais recente do tipo API
- Não depende mais do nome da caixa para encontrar
- Ordenação por data garante que encontre a última criada

# Correção da Verificação de Canal na Busca de Inbox
- Ajustada verificação do tipo de canal para aceitar 'Channel::Api' ou 'api'
- Adicionados logs para debug da verificação de cada inbox
- Mantido fluxo de polling com 3 tentativas a cada 2 segundos

#importante
- Verificação de canal agora aceita ambos os formatos: Channel::Api e api
- Logs detalhados para rastrear processo de verificação de cada inbox

## 2024-01-25
- Corrigido processo de exclusão de instâncias Evolution:
  - Ajustado método extract_evolution_instance_name para usar nome exato da instância
  - Removida duplicação na chamada de exclusão
  - Garantido que o nome da instância inclui o sufixo completo (ex: nome_SC3_hash)

# Importante
- A exclusão de instâncias Evolution agora usa o nome exato da instância (incluindo sufixo _SC3_hash)
- Apenas uma chamada de exclusão é feita para cada instância
- Endpoint da Evolution API mantido como http://192.168.15.4:8080

## Bug Fixes
- Corrigido bug no pollForInbox que não encontrava inboxes do tipo Evolution e WhatsApp. Adicionado suporte para channel_type: evolution, api e whatsapp. Removidos logs desnecessários que poderiam expor informações sensíveis.

## Alterações de Redirecionamento WhatsApp
- Modificado o redirecionamento no WhatsAppWeb.vue para usar Vue Router primeiro e fallback para window.location
- Adicionado logs para debug do redirecionamento
- Verificado retorno correto do controller evolution with inbox_id

**#importante** O redirecionamento agora tenta usar o Vue Router antes de recorrer ao window.location, mantendo o estado da aplicação quando possível

## Simplificação do Redirecionamento WhatsApp
- Removida tentativa de usar Vue Router para evitar conflitos
- Usando window.location.href diretamente para garantir redirecionamento
- Ajustada verificação de tipo de canal no controller para incluir 'Channel::Evolution', 'Channel::Api' e 'api'

**#importante** Redirecionamento simplificado usando apenas window.location.href e verificação de canal mais abrangente

## Ajustes no Redirecionamento WhatsApp
- Alterado window.location.href para window.location.replace para forçar redirecionamento
- Adicionado delay de 1 segundo antes do redirecionamento para garantir processamento
- Melhorados logs para debug do ID da caixa e dados de redirecionamento
- Adicionadas informações adicionais na resposta do controller (nome e tipo do canal)

**#importante** Redirecionamento mais robusto usando window.location.replace e delay controlado para garantir processamento dos dados

## Correção na Atualização de Inboxes
- Forçada atualização da lista de inboxes com validateHash: false
- Melhorado retorno de dados na action get do store
- Adicionados logs para debug das respostas
- Ajustado tratamento de erros para ser mais informativo

**#importante** Atualização de inboxes agora força busca no servidor ignorando cache e retorna dados completos

## Reversão e Correção da API de Inboxes
- Revertida alteração na action get do store de inboxes
- Removida forçagem de validateHash na busca de inboxes
- Simplificado processo de verificação e redirecionamento
- Mantido window.location.replace para redirecionamento direto

**#importante** API de inboxes restaurada ao funcionamento original, mantendo compatibilidade com o cache do sistema

## Nova Abordagem de Verificação de Inbox Criada
- Implementada nova lógica de verificação baseada na comparação de IDs
- Armazenada lista de IDs de inboxes antes da criação
- Verificação busca por novo ID que não existia na lista anterior
- Redirecionamento direto quando encontra novo ID

**#importante** Verificação simplificada: compara IDs antes e depois da criação, sem depender de tipos de canal ou outras verificações

## Restrição de Verificação ao Fluxo WhatsApp Web
- Adicionada flag isWhatsAppWebFlow para identificar o fluxo
- Verificação de novo ID só acontece se estiver no fluxo WhatsApp Web
- Mantida lógica de comparação de IDs apenas para este fluxo específico

**#importante** Verificação de novo ID e redirecionamento automático agora são exclusivos para o fluxo de criação de WhatsApp Web

## Correção no Tratamento da Resposta de Inboxes
- Ajustado tratamento da resposta do fetchInboxes para lidar com undefined
- Adicionada validação extra na estrutura da resposta
- Garantido que sempre teremos um array mesmo com resposta vazia
- Passado validateHash: true para garantir consistência

**#importante** Tratamento mais robusto da resposta de inboxes para evitar erros de undefined

## Adição de Loading Temporário no Botão de Criação
- Adicionado estado buttonLoading para controlar loading do botão
- Loading ativo por 5 segundos após o clique
- Botão desabilitado durante o loading para evitar múltiplos cliques
- Loading independente do processo de criação

**#importante** Botão de criação agora tem proteção contra múltiplos cliques com loading de 5 segundos

## Controle de Visibilidade de Abas e Campos
- Adicionada lógica para ocultar aba "Configuração" quando webhook_url contém "chatwoot"
- Adicionada lógica para ocultar campos específicos na aba "Configuração" quando webhook_url contém "chatwoot":
  - Nome da Caixa de Entrada
  - URL do webhook
  - Token de validação HMAC
  - Campos de validação de identidade do usuário

**#importante** Controle de visibilidade baseado no conteúdo do webhook_url implementado para melhor organização das configurações

## Correção da Visibilidade de Campos na Aba Settings
- Adicionada condição v-if="!isWebhookChatwoot" no campo de nome da caixa de entrada
- Ajustada condição do campo webhook_url para v-if="isAPIInbox && !isWebhookChatwoot"
- Campos agora são ocultados corretamente quando webhook_url contém "chatwoot"

**#importante** Campos de nome da caixa e webhook_url agora são ocultados corretamente na aba Settings quando webhook_url contém "chatwoot"

# Cursor Logs

## Alterações Importantes

- Atualizado o sistema de atribuição automática de conversas:
  - A atribuição ao visualizar só acontece se a opção enable_auto_assignment estiver ativada na caixa de entrada
  - Condições para atribuição automática:
    1. Conversa não está resolvida
    2. Conversa não está atribuída
    3. Usuário é um agente
    4. Caixa de entrada tem atribuição automática ativada
  - Arquivos alterados: 
    - app/controllers/api/v1/accounts/conversations_controller.rb

# Alterações em 2024-03-19 (2)
- Modificado o sistema de atribuição automática de conversas:
  - Adicionada atribuição automática ao clicar em uma conversa na lista
  - A atribuição acontece se:
    1. A conversa não está resolvida
    2. A conversa não tem atribuição
  - A atribuição é feita usando a rota de assignments (/api/v1/accounts/:account_id/conversations/:id/assignments)
  - Arquivos alterados:
    - app/javascript/dashboard/components/widgets/conversation/ConversationCard.vue

## Campanhas no Chatwoot

### Tipos:
- Ongoing (Live Chat): Campanhas contínuas no widget do site
- One-off (SMS): Campanhas únicas via SMS

### Funcionalidades:
- Regras de disparo (URL, tempo na página, horário comercial)
- Personalização de mensagens e remetentes
- Integração com widget e sistema de conversas
- Suporte a múltiplos canais (Web, SMS)
- Controles de execução e monitoramento

#importante Campanhas podem ser configuradas como contínuas (widget) ou únicas (SMS) com regras específicas de disparo e personalização

**#importante** Permissões de agente: 'conversation_unassigned_manage' requer 'conversation_participating_manage' para funcionar corretamente na visualização de conversas

## Restauração da Lógica de Atribuição Automática
- Restaurada lógica original de atribuição automática:
  - Removida atribuição automática do ConversationCard.vue
  - Restaurada verificação de enable_auto_assignment no ConversationsController
  - A atribuição automática agora só acontece se:
    1. A conversa não está resolvida
    2. A conversa não tem atribuição
    3. O usuário é um agente
    4. A caixa de entrada tem atribuição automática ativada (enable_auto_assignment)

**#importante** A atribuição automática de conversas agora respeita a configuração enable_auto_assignment da caixa de entrada

## Alteração na Atribuição Automática de Conversas
- Movida a lógica de atribuição automática para o frontend:
  - Removida atribuição automática do backend (ConversationsController)
  - Adicionada atribuição automática no ConversationCard.vue ao clicar na conversa
  - A atribuição acontece se:
    1. A conversa não está resolvida
    2. A conversa não tem atribuição
  - A atribuição é feita usando a action assignAgent do Vuex store

**#importante** A atribuição automática agora acontece no frontend quando o usuário clica em uma conversa não atribuída e não resolvida

## Correção do Filtro "All" nas Conversas
- Ajustado o comportamento do filtro "all" para respeitar as permissões do usuário:
  - No frontend (permissions.js): adicionada permissão de conversas não atribuídas ao filtro "all"
  - No backend (conversation_finder.rb): modificada lógica do filtro "all" para:
    1. Administradores: veem todas as conversas
    2. Agentes com ambas permissões: veem conversas não atribuídas + participando
    3. Agentes com permissão de não atribuídas: veem apenas conversas não atribuídas
    4. Agentes com permissão de participando: veem apenas conversas em que participam
    5. Agentes sem permissões específicas: veem apenas suas conversas atribuídas

**#importante** O filtro "all" agora respeita as permissões do usuário, mostrando apenas as conversas que ele tem permissão para ver

- Redis testado e funcionando corretamente no container shared_redis (versão 7.4.2) na porta 6379