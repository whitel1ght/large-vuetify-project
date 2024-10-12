<template>
  <v-form ref="userWithPasswordForm">
    <v-text-field
      v-model="form.name"
      :label="t('Users.withPassword.name')"
    />
    <v-text-field
      v-model="form.surname"
      :label="t('Users.withPassword.surname')"
    />
    <v-text-field
      v-model="form.password"
      :label="t('Users.withPassword.password')"
    />
  </v-form>
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted, Ref } from 'vue'
import { useI18n } from 'vue-i18n'
// types
import { UserType } from '@/types/User'
import { UserWithPassword } from '@/types/UserWithPassword'
import { Emitter } from 'mitt'

type Events = { 'submit': void }

interface UserWithPasswordFormProps {
  eventBus: Emitter<Events>
  user?: UserWithPassword
}

const props = defineProps<UserWithPasswordFormProps>()
const emit = defineEmits(['submit:form'])

// composables
const { t } = useI18n()
// constants
const data = { name: '', surname: '', password: '' }

// refs
const userWithPasswordForm: Ref = ref(null)

// reactive
const form = reactive(data)

// methods
const onClose = () => {
  userWithPasswordForm.value.resetValidation()
  Object.assign(form, data)
}

const create = async (data: UserWithPassword) => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve(data)
    }, 1000)
  })
  onClose()
}

const update = async (data: UserWithPassword) => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve(data)
    }, 1000)
  })
  onClose()
}

const submit = async () => {
  const { valid = false } = await userWithPasswordForm.value.validate()
  if (!valid) return

  const data: UserWithPassword = {
    id: props.user?.id || '',
    type: UserType.WITH_PASSWORD,
    name: form.name,
    surname: form.surname,
    password: form.password
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

onUnmounted(() => {
  props.eventBus.off('submit', submit)
})

//
if (props.user) {
  Object.assign(form, props.user)
}
</script>
