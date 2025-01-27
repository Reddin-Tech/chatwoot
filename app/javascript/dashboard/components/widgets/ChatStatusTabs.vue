<script setup>
import { computed } from 'vue';
import { useKeyboardEvents } from 'dashboard/composables/useKeyboardEvents';
import wootConstants from 'dashboard/constants/globals';

const props = defineProps({
  items: {
    type: Array,
    default: () => [],
  },
  activeTab: {
    type: String,
    default: wootConstants.STATUS_TYPE.OPEN,
  },
});

const emit = defineEmits(['statusTabChange']);

const activeTabIndex = computed(() => {
  return props.items.findIndex(item => item.key === props.activeTab);
});

const onTabChange = selectedTabIndex => {
  if (selectedTabIndex >= 0 && selectedTabIndex < props.items.length) {
    const selectedItem = props.items[selectedTabIndex];
    if (selectedItem.key !== props.activeTab) {
      emit('statusTabChange', selectedItem.key);
    }
  }
};

const keyboardEvents = {
  'Alt+KeyS': {
    action: () => {
      if (props.activeTab === wootConstants.STATUS_TYPE.ALL) {
        onTabChange(0);
      } else {
        const nextIndex = (activeTabIndex.value + 1) % props.items.length;
        onTabChange(nextIndex);
      }
    },
  },
};

useKeyboardEvents(keyboardEvents);
</script>

<template>
  <woot-tabs
    :index="activeTabIndex"
    class="w-full px-4 py-0 tab--chat-status"
    is-compact
    @change="onTabChange"
  >
    <woot-tabs-item
      v-for="(item, index) in items"
      :key="item.key"
      :index="index"
      :name="item.name"
      :count="item.count"
      :show-badge="false"
    />
  </woot-tabs>
</template>

<style scoped lang="scss">
.tab--chat-status {
  ::v-deep {
    .tabs {
      @apply p-0;
    }
  }
}
</style> 