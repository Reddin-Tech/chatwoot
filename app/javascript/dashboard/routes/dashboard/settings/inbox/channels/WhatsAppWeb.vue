<script>
import { mapGetters, mapActions } from 'vuex';
import { useVuelidate } from '@vuelidate/core';
import { useAlert } from 'dashboard/composables';
import { required } from '@vuelidate/validators';
import router from '../../../../index';

export default {
  setup() {
    return { v$: useVuelidate() };
  },
  data() {
    return {
      inboxName: '',
      isCreating: false,
      isCheckingInbox: false,
      previousInboxIds: [],
      isWhatsAppWebFlow: true,
      buttonLoading: false,
    };
  },
  computed: {
    ...mapGetters({ uiFlags: 'inboxes/getUIFlags' }),
    isInAgentsPage() {
      return this.$route.name === 'settings_inbox_agents';
    },
  },
  validations: {
    inboxName: { required },
  },
  methods: {
    ...mapActions({
      createEvolutionInstance: 'inboxes/createEvolutionInstance',
      fetchInboxes: 'inboxes/get',
    }),
    async checkCreatedInbox() {
      if (!this.isWhatsAppWebFlow) {
        return false;
      }

      let attempts = 0;
      const maxAttempts = 5;
      const checkInterval = 3000;

      while (attempts < maxAttempts) {
        try {
          const response = await this.fetchInboxes({ validateHash: true });
          const currentInboxes = ((response || {}).payload || []);
          const currentInboxIds = currentInboxes.map(inbox => inbox.id);

          const newInboxId = currentInboxIds.find(id => !this.previousInboxIds.includes(id));

          if (newInboxId) {
            const accountId = this.$route.params.accountId;
            const redirectPath = `/app/accounts/${accountId}/settings/inboxes/new/${newInboxId}/agents`;
            window.location.replace(redirectPath);
            return true;
          }
        } catch (error) {
          // Continua tentando em caso de erro
        }

        attempts += 1;
        if (attempts < maxAttempts) {
          await new Promise(resolve => setTimeout(resolve, checkInterval));
        }
      }

      useAlert(
        'Clique na engrenagem da caixa criada e finalize a configuração.',
        'warning'
      );
      
      const fallbackPath = `/app/accounts/${this.$route.params.accountId}/settings/inboxes/list`;
      window.location.replace(fallbackPath);
      return false;
    },
    async createChannel() {
      this.v$.$touch();
      if (this.v$.$invalid || this.buttonLoading) {
        return;
      }

      // Ativa loading do botão por 5 segundos
      this.buttonLoading = true;
      setTimeout(() => {
        this.buttonLoading = false;
      }, 10000);

      try {
        const currentResponse = await this.fetchInboxes({ validateHash: true });
        this.previousInboxIds = ((currentResponse || {}).payload || []).map(inbox => inbox.id);

        this.isCreating = true;
        const response = await this.createEvolutionInstance({
          name: this.inboxName,
          accountId: this.$route.params.accountId,
        });

        if (response?.data?.success) {
          useAlert(response.data.message, 'success');
          this.isCheckingInbox = true;
          await this.checkCreatedInbox();
        } else {
          throw new Error(
            response?.data?.error ||
              response?.error ||
              this.$t('INBOX_MGMT.ADD.WHATSAPP.API.ERROR_MESSAGE')
          );
        }
      } catch (error) {
        useAlert(
          error.message || this.$t('INBOX_MGMT.ADD.WHATSAPP.API.ERROR_MESSAGE'),
          'error'
        );
      } finally {
        this.isCreating = false;
        this.isCheckingInbox = false;
      }
    },
  },
};
</script>

<template>
  <form class="flex flex-wrap mx-0" @submit.prevent="createChannel()">
    <div class="w-[65%] flex-shrink-0 flex-grow-0 max-w-[65%]">
      <label :class="{ error: v$.inboxName.$error }">
        {{ $t('INBOX_MGMT.ADD.WHATSAPP.INBOX_NAME.LABEL') }}
        <input
          v-model="inboxName"
          type="text"
          :placeholder="$t('INBOX_MGMT.ADD.WHATSAPP.INBOX_NAME.PLACEHOLDER')"
          @blur="v$.inboxName.$touch"
        />
        <span v-if="v$.inboxName.$error" class="message">
          {{ $t('INBOX_MGMT.ADD.WHATSAPP.INBOX_NAME.ERROR') }}
        </span>
      </label>
    </div>

    <div class="w-full">
      <woot-submit-button
        :loading="isCreating || isCheckingInbox || buttonLoading"
        :disabled="isCreating || isCheckingInbox || buttonLoading"
        :button-text="$t('INBOX_MGMT.ADD.WHATSAPP.SUBMIT_BUTTON')"
      />
    </div>
  </form>
</template> 