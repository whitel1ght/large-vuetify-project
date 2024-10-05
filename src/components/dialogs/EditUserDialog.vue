<template>
  <v-dialog
    v-model="internalModel"
    width="600"
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
          :user="props.user"
          @close:dialog="close"
          @submit:form="submit"
        />
      </v-card-text>

      <v-card-actions>
        <v-btn
          variant="text"
          @click="$emit('update:modelValue', false)"
        >
          Cancel
        </v-btn>
        <v-btn
          variant="tonal"
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
import { UserType, User } from '@/types/User'
// utils
import mitt from 'mitt'

interface EditUserDialogProps {
  modelValue: boolean
  user: User
}

const props = defineProps<EditUserDialogProps>()
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

  const types: Map<UserType, string> = new Map([
    [UserType.WITH_NUMBER, 'UserWithNumberForm'],
    [UserType.WITH_PASSWORD, 'UserWithPasswordForm']
  ])

  const userType: UserType = props.user.type


  return forms[types.get(userType)!] as any
})

// methods
function close() {
  internalModel.value = false
}

function submit() {
  eventBus.emit('submit:form')
}
</script>
