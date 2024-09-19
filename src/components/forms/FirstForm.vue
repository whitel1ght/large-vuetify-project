<template>
  <v-form ref="firstFormRef">
    <v-text-field
      v-model="name"
      label="Name"
      required
    />
    <v-text-field
      v-model="accessToken"
      label="Access Token"
      required
    />
    <v-text-field
      v-model="refreshToken"
      label="Refresh Token"
      required
    />
  </v-form>
</template>

<script setup>
import { ref, reactive } from 'vue'

const props = defineProps({
  userData: Object,
  eventBus: Object
})

const data = {
  name: '',
  accessToken: '',
  refreshToken: ''
}

// refs
const firstFormRef = ref(null)

// reactive
const form = reactive(data)

// methods
const onClose = () => {
  firstFormRef.value.resetValidation()
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
  const { valid = false } = await firstFormRef.value.validate()
  if (!valid) return

  const data = {
    name: form.name,
    accessToken: form.accessToken,
    refreshToken: form.refreshToken
  }

  if (props.userData) { {
    await update(userData)
  } else {
    await create(userData)
  }
}

props.eventBus.on('submit', () => {

})
</script>
