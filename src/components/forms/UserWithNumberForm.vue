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
import { ref, reactive, onBeforeUnmount } from 'vue'
import { UserType } from '@/types/User'

const props = defineProps({
  user: Object,
  eventBus: Object
})

const emit = defineEmits(['submit:form', 'close:dialog'])

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
  emit('close:dialog')
  userWithNumberForm.value.resetValidation()
  Object.assign(form, data)
}

const create = async data => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve('created')
      console.log('created', data)
    }, 1000)
  })
}

const update = async data => {
  await new Promise(resolve => {
    setTimeout(() => {
      resolve('updated')
    }, 1000)
  })
}

const submit = async () => {
  const { valid = false } = await userWithNumberForm.value.validate()
  if (!valid) return

  const data = {
    type: UserType.WITH_NUMBER,
    name: form.name,
    phoneNumber: form.phoneNumber,
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
