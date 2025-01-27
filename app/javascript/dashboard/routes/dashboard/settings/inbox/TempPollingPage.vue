<template>
  <div class="temp-polling-page">
    <div class="flex items-center justify-center h-screen">
      <div class="text-center">
        <spinner size="large" />
        <p class="mt-4 text-slate-700 dark:text-slate-100">
          {{ $t('SETTINGS.INBOXES.ADD.CONFIGURING') }}
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import Spinner from 'shared/components/Spinner.vue';

export default {
  name: 'TempPollingPage',
  components: {
    Spinner
  }
};
</script>

<style lang="scss" scoped>
.temp-polling-page {
  min-height: 100vh;
  background-color: var(--color-background);
}
</style> 