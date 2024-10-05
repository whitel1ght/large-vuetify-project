<template>
  <v-form ref="userWithPasswordForm">
    <v-text-field
      v-model="form.name"
      label="Name"
      required
    />
    <v-text-field
      v-model="form.surname"
      label="Surname"
      required
    />
    <v-text-field
      v-model="form.password"
      label="Password"
      required
    />
  </v-form>
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted } from 'vue'
// types
import { UserType } from '@/types/User'
import { UserWithPassword } from '@/types/UserWithPassword'
import { Emitter } from 'mitt'

type Events = { 'submit': void }

interface UserWithPasswordFormProps {
  eventBus: Emitter<Events>
  user: UserWithPassword
}

const props = defineProps<UserWithPasswordFormProps>()
const emit = defineEmits(['submit:form'])

// refs
const data = { name: '', surname: '', password: '' }
const userWithPasswordForm = ref(null)

// reactive
const form = reactive(data)

// methods
const onClose = () => {
  userWithPasswordForm.value.resetValidation()
  Object.assign(form, data)
}

const create = async () => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve('created')
    }, 1000)
  })
  onClose()
}

const update = async () => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve('updated')
    }, 1000)
  })
  onClose()
}

const submit = async () => {
  const { valid = false } = await userWithPasswordForm.value.validate()
  if (!valid) return

  const data: UserWithPassword = {
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
