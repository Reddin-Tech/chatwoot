# Monitoramento de Comunicações Externas

## Endpoints do Hub que devem estar bloqueados
1. https://hub.2.chatwoot.com/ping
2. https://hub.2.chatwoot.com/instances
3. https://hub.2.chatwoot.com/send_push
4. https://hub.2.chatwoot.com/events
5. https://hub.2.chatwoot.com/billing
6. https://hub.2.chatwoot.com/instance_captain_accounts

## Como Monitorar
```bash
# Monitorar chamadas de rede
sudo tcpdump -n host hub.2.chatwoot.com

# Verificar logs por tentativas de conexão
tail -f log/development.log | grep -i "hub.2.chatwoot.com"

# Verificar variáveis de ambiente
env | grep -i "chatwoot\|telemetry\|hub"
```

## Pontos de Verificação
1. Onboarding não deve tentar registrar a instância
2. Job de verificação de versões não deve tentar sincronizar
3. Notificações push devem usar configuração local
4. Eventos não devem ser enviados externamente

## Em Caso de Tentativa de Conexão
1. Verificar qual código está tentando fazer a chamada
2. Confirmar que CHATWOOT_HUB_URL está vazio
3. Confirmar que DISABLE_TELEMETRY=true
4. Verificar se há algum serviço tentando usar push notifications 