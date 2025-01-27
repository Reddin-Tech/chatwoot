<template>
  <div class="create-inbox">
    <div class="medium-8 medium-offset-2">
      <form @submit.prevent="handleCreate">
        <div class="row">
          <div class="medium-12 columns">
            <label>
              {{ $t('INBOX_MGMT.ADD.INBOX_NAME.LABEL') }}
              <input 
                v-model="inboxName"
                type="text"
                :placeholder="$t('INBOX_MGMT.ADD.INBOX_NAME.PLACEHOLDER')"
                :disabled="isLoading"
              />
            </label>
          </div>
        </div>

        <div class="row actions">
          <div class="medium-12 columns">
            <button 
              class="button nice rounded-md" 
              :disabled="isLoading || !inboxName"
            >
              <Spinner v-if="isLoading" />
              {{ $t('SETTINGS.INBOXES.ADD.CREATE') }}
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import Spinner from 'shared/components/Spinner.vue';

export default {
  name: 'CreateInbox',
  components: {
    Spinner,
  },
  
  data() {
    return {
      isLoading: false,
      inboxName: '',
    };
  },
  
  computed: {
    ...mapGetters({
      getInboxes: 'inboxes/getInboxes',
    }),
    
    accountId() {
      return this.$route.params.accountId;
    },
  },
  
  methods: {
    async handleCreate() {
      if (!this.inboxName) {
        return;
      }

      try {
        this.isLoading = true;
        
        // 1. Criar a caixa de entrada
        const createdInbox = await this.createInbox();
        console.log('[CreateInbox] Inbox criada com sucesso:', createdInbox);
        
        // 2. Redirecionar para página temporária
        const tempRoute = `/app/accounts/${this.accountId}/settings/inboxes/temp`;
        console.log('[CreateInbox] Redirecionando para:', tempRoute);
        await this.$router.push(tempRoute);
        
        // 3. Iniciar polling com logs
        console.log('[CreateInbox] Iniciando polling');
        
        // Forçar atualização da lista antes de iniciar polling
        console.log('[CreateInbox] Atualizando lista de inboxes');
        await this.$store.dispatch('inboxes/get', { validateHash: false });
        
        const foundInbox = await this.$store.dispatch('inboxes/pollForInbox', {
          maxAttempts: 3,
          interval: 2000,
        });
        
        console.log('[CreateInbox] Resultado do polling:', foundInbox);
        
        // 4. Redirecionar baseado no resultado
        if (foundInbox) {
          console.log('[CreateInbox] Inbox encontrada, redirecionando para configuração de agentes');
          await this.$router.push({
            name: 'settings_inboxes_add_agents',
            params: {
              accountId: this.accountId,
              inbox_id: foundInbox.id
            }
          });
        } else {
          console.log('[CreateInbox] Inbox não encontrada, redirecionando para lista');
          await this.$router.push({
            name: 'settings_inbox_list',
            params: {
              accountId: this.accountId
            }
          });
          this.$store.dispatch('notifications/show', {
            type: 'info',
            message: 'Clique na engrenagem da caixa criada e finalize a configuração',
          });
        }
        
      } catch (error) {
        console.error('[CreateInbox] Erro ao criar inbox:', error);
        this.$store.dispatch('notifications/show', {
          type: 'error',
          message: error.message || 'Erro ao criar caixa de entrada',
        });
      } finally {
        this.isLoading = false;
      }
    },
    
    async createInbox() {
      const params = {
        name: this.inboxName,
        channel: {
          type: 'api',
        },
      };
      
      const response = await this.$store.dispatch('inboxes/createChannel', params);
      return response;
    },
  },
};
</script>

<style lang="scss" scoped>
.create-inbox {
  padding: var(--space-normal);
  
  .actions {
    margin-top: var(--space-normal);
  }
}
</style> 