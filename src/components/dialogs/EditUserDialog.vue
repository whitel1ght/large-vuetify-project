<template>
  <v-dialog
    v-model="internalModel"
    @click:outside="internalModel = false"
    @keydown.esc="internalModel = false"
  >
    <v-card>
      <v-card-title>
        <span class="headline">Edit User</span>
      </v-card-title>

      <v-card-text>
        <component
          :is="currentForm"
          :event-bus="eventBus"
          @close:dialog="close"
          @submit:form="submit"
        />
      </v-card-text>

      <v-card-actions>
        <v-btn
          text
          @click="$emit('update:modelValue', false)"
        >
          Cancel
        </v-btn>
        <v-btn
          text
          @click="submit"
        >
          Submit
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { defineAsyncComponent, computed  } from 'vue'
// types
import { UserType } from '@/types/User'
// utils
import mitt from 'mitt'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  user: Object
})

const emit = defineEmits(['update:modelValue'])

// constants
const eventBus = mitt()

// computeds
const internalModel = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
})

const currentForm = computed(() => {
  const forms = {
    UserWithNumberForm: defineAsyncComponent(() => import('@/components/forms/UserWithNumberForm.vue')),
    UserWithPasswordForm: defineAsyncComponent(() => import('@/components/forms/UserWithPasswordForm.vue'))
  }

  const types = new Map([
    [UserType.WITH_NUMBER, 'UserWithNumberForm'],
    [UserType.WITH_PASSWORD, 'UserWithPasswordForm']
  ])

  return forms[types.get(props.user.type)]
})

// methods
function close() {
  internalModel.value = false
}

function submit() {
  eventBus.emit('submit:form')
}
</script>
