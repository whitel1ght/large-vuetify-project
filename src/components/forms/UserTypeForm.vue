<template>
  <v-form>
    <v-select
      v-model="internalModel"
      :items="types"
      label="User Type"
      required
    />
  </v-form>
</template>

<script setup>
import { reactive, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { USER_TYPES_MAP } from '@/utils/users'


const props = defineProps({ modelValue: String })
const emit = defineEmits(['update:modelValue'])

const { t } = useI18n()

const internalModel = computed({
  get: () => props.modelValue,
  set: val => emit('update:modelValue', val)
})

const types = [...USER_TYPES_MAP.values()].map(type => t(type))

// feature:add-user
</script>
