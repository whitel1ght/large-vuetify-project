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

const props = defineProps({ modelValue: String })
const emit = defineEmits(['update:modelValue'])

const internalModel = computed({
  get: () => props.modelValue,
  set: val => emit('update:modelValue', val)
})

// composable with translations here ?
const types = [ 'User With Number', 'User With Password' ]

</script>
