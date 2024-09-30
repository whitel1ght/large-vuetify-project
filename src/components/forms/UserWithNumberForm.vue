<template>
  <v-form ref="userWithNumberForm">
    <v-text-field
      v-model="form.name"
      label="Name"
      required
    />
    <v-text-field
      v-model="form.phoneNumber"
      label="Phone Number"
      required
    />
    <v-text-field
      v-model="form.messengers"
      label="Messengers"
      required
    />
  </v-form>
</template>

<script setup>
import { ref, reactive } from 'vue'

const props = defineProps({
  user: Object,
  eventBus: Object
})

const data = {
  name: '',
  phoneNumber: '',
  messengers: ''
}

// refs
const userWithNumberForm = ref(null)

// reactive
const form = reactive(data)

// methods
const onClose = () => {
  userWithNumberForm.value.resetValidation()
  Object.assign(form, data)
}

const create = async data => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve('created')
    }, 1000)
  })
  onClose()
}

const update = async data => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve('updated')
    }, 1000)
  })
  onClose()
}

const submit = async () => {
  const { valid = false } = await userWithNumberForm.value.validate()
  if (!valid) return

  const data = {
    name: form.name,
    phoneNumber: form.phoneNumber,
    messengers: form.messengers
  }

  if (props.userData) {
    await update(userData)
  } else {
    await create(userData)
  }
}

props.eventBus.on('submit', () => {
  emit('submit:form')
  onClose()
})
</script>
