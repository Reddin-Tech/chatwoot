# Comandos Relevantes

## Docker
- `docker compose -f docker-compose.test.yaml down` - Para todos os containers
- `docker compose -f docker-compose.test.yaml build --no-cache` - Reconstrói as imagens sem usar cache
- `docker compose -f docker-compose.test.yaml up -d` - Inicia os containers em background
- `docker compose -f docker-compose.test.yaml exec rails comando` - Executa um comando no container rails
- `docker compose -f docker-compose.test.yaml logs -f vite` - Acompanha os logs do serviço Vite
- `docker compose -f docker-compose.test.yaml restart rails` - Reinicia o container do Rails mantendo as configurações
- `docker compose -f docker-compose.test.yaml run --rm rails bundle exec rails db:migrate` - Executa migrações usando o docker-compose.test.yaml

## Assets
- `bundle exec rake assets:precompile`
## Evolution API
DELETE http://192.168.15.4:8080/instance/delete/{NOME_INSTANCIA}
Headers:
- Content-Type: application/json
- apikey: 1f31f46873429a0527b7f148c924b35f3118e8e7ee3a4aa3cf51b7eaa066ac0820f52070299f303beef3e3d693685906197129e9a3bdb39970fbc0e6764fd133

# Variáveis de Ambiente Necessárias
```bash
EVOLUTION_API_URL=http://localhost:8080  # URL da Evolution API
API_ACCESS_TOKEN=your_api_token          # Token de acesso da Evolution API
FRONTEND_URL=http://localhost:3000       # URL do frontend do Chatwoot
```

## Debug de Criação de Caixa
- Verificar logs do frontend no console do navegador para acompanhar o polling
- Verificar chamadas de API no Network do navegador:
  - POST /api/v1/accounts/{id}/inboxes/evolution - Criar caixa
  - GET /api/v1/accounts/{id}/inboxes - Polling para verificar criação

# Headers de Autenticação Necessários
```bash
# Headers obrigatórios para chamadas à API
access-token: [TOKEN]  # Token de acesso
client: [CLIENT_ID]    # ID do cliente
uid: [USER_EMAIL]      # Email do usuário

# Exemplo de chamada com autenticação
curl -X GET "http://localhost:3000/api/v1/accounts/3/inboxes" \
  -H "access-token: [TOKEN]" \
  -H "client: [CLIENT_ID]" \
  -H "uid: [USER_EMAIL]"
```

# Comandos para Debug do Vite
```bash
# Reconstruir assets do Vite
docker compose -f docker-compose.test.yaml exec rails bin/vite build --clear --mode=development

# Reiniciar Rails após alterações em JS
docker compose -f docker-compose.test.yaml restart rails

# Ver logs do Vite em tempo real
docker compose -f docker-compose.test.yaml logs -f vite
```

# Logs
tail -f log/development.log | grep "Evolution API" # Para monitorar logs de sincronização com Evolution

## Campanhas

### Visualização
- `GET /api/v1/accounts/{account_id}/campaigns` - Listar todas as campanhas
- `GET /api/v1/accounts/{account_id}/campaigns/{id}` - Visualizar campanha específica

### Gerenciamento
- `POST /api/v1/accounts/{account_id}/campaigns` - Criar nova campanha
- `PUT /api/v1/accounts/{account_id}/campaigns/{id}` - Atualizar campanha
- `DELETE /api/v1/accounts/{account_id}/campaigns/{id}` - Remover campanha

### Execução
- Campanhas Live Chat são executadas automaticamente baseadas nas regras de disparo
- Campanhas SMS são executadas no horário agendado via serviços Twilio::OneoffSmsCampaignService ou Sms::OneoffSmsCampaignService
