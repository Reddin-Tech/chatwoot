# Monitoramento de Funcionalidades Enterprise

## Pontos de Atenção
1. Verificar periodicamente:
   - [ ] Criação de novos usuários (limite)
   - [ ] Acesso às rotas enterprise
   - [ ] Funcionamento dos webhooks
   - [ ] Integrações com serviços externos
   - [ ] Funcionalidades premium/enterprise

## Funcionalidades que Dependem do Enterprise
1. Rotas `/enterprise/*`
2. Webhooks personalizados
3. Integrações avançadas
4. Limites de usuários
5. Features premium

## Como Verificar
```bash
# No console Rails
ChatwootApp.enterprise? # deve retornar true
ChatwootHub.pricing_plan # deve retornar 'premium'
ChatwootHub.pricing_plan_quantity # deve retornar 999999

# Verificar rotas
rails routes | grep enterprise

# Verificar logs por erros
tail -f log/development.log | grep -i "enterprise\|premium\|license"
```

## Em Caso de Problemas
1. Verificar todas as variáveis de ambiente
2. Confirmar que ENTERPRISE_MODE=true
3. Verificar se CW_EDITION=enterprise
4. Confirmar INSTALLATION_PRICING_PLAN=premium
5. Verificar logs por erros específicos 