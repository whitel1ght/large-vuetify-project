<template>
  <v-form ref="userWithNumberForm">
    <v-text-field
      v-model="form.name"
      :label="t('Users.withNumber.name')"
    />
    <v-text-field
      v-model="form.phoneNumber"
      :label="t('Users.withNumber.phoneNumber')"
    />
    <v-text-field
      v-model="form.messengers"
      :label="t('Users.withNumber.messengers')"
    />
  </v-form>
</template>

<script setup lang="ts">
import { ref, reactive, onBeforeUnmount, Ref } from 'vue'
// composables
import { useI18n } from 'vue-i18n'
// types
import { UserType } from '@/types/User'
import type { UserWithNumber } from '@/types/UserWithNumber'
import { Emitter } from 'mitt'

type Events = { 'submit': void }

interface UserWithNumberFormProps {
  eventBus: Emitter<Events>
  user: UserWithNumber
}

const props = defineProps<UserWithNumberFormProps>()
const emit = defineEmits(['submit:form'])

// composables
const { t } = useI18n()

// constants
const data = { name: '', phoneNumber: '', messengers: '' }

// refs
const userWithNumberForm: Ref = ref(null)

// reactive
const form = reactive(data)

// methods
const onClose = () => {
  userWithNumberForm.value?.resetValidation()
  Object.assign(form, data)
}

const create = async (data: UserWithNumber) => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve(data)
    }, 1000)
  })
}

const update = async (data: UserWithNumber) => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve(data)
    }, 1000)
  })
}

const submit = async () => {
  const { valid = false } = await userWithNumberForm.value.validate()
  if (!valid) return

  const data: UserWithNumber = {
    id: props.user?.id || '',
    type: UserType.WITH_NUMBER,
    name: form.name,
    phoneNumber: Number(form.phoneNumber),
    messengers: form.messengers
  }

  if (props.user) {
    await update(data)
  } else {
    await create(data)
  }
  emit('submit:form', data)
  onClose()
}

props.eventBus.on('submit', submit)

onBeforeUnmount(() => {
  props.eventBus.off('submit', submit)
})

//
if (props.user) {
  Object.assign(form, props.user)
}
</script>
