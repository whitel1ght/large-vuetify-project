<template>
  <v-dialog
    v-model="show"
    width="600"
  >
    <v-stepper v-model="step">
      <v-stepper-header>
        <v-stepper-item
          :complete="step > 1"
          step="1"
          :value="1"
        >
          Select User Type
        </v-stepper-item>

        <v-divider />

        <v-stepper-item
          :complete="step > 2"
          step="2"
          :value="2"
        >
          Add User
        </v-stepper-item>
      </v-stepper-header>

      <v-stepper-window>
        <v-stepper-window-item :value="1">
          <user-type-form v-model="type" />
        </v-stepper-window-item>

        <v-stepper-window-item :value="2">
          <component
            :is="nextStepForm"
            :event-bus="eventBus"
            @close:dialog="close"
            @submit:form="submit"
          />
        </v-stepper-window-item>
      </v-stepper-window>

      <div class="d-flex justify-space-between align-center mx-4 py-2">
        <v-btn
          v-if="step > 1"
          variant="text"
          dark
          @click="prev"
        >
          Back
        </v-btn>

        <div class="d-flex flex-grow-1 justify-end">
          <v-btn
            variant="text"
            @click="show = false"
            >
            Cancel
          </v-btn>

          <v-btn
            variant="text"
            @click="submit"
          >
            Submit
          </v-btn>
        </div>
      </div>
    </v-stepper>
  </v-dialog>
</template>

<script setup>
import { ref, computed, defineAsyncComponent } from 'vue'
// components
import UserTypeForm from '@/components/forms/UserTypeForm.vue'
// utils
import mitt from 'mitt'

const props = defineProps({ modelValue: Boolean })
const emit = defineEmits(['update:modelValue', 'close:dialog', 'submit:form'])

// consts
const eventBus = mitt()

// refs
const step = ref(1)
const type = ref('User With Number')

// computeds
const show = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
})

const nextStepForm = computed(() => {
  const forms = {
    UserWithNumberForm: defineAsyncComponent(() => import('@/components/forms/UserWithNumberForm.vue')),
    UserWithPasswordForm: defineAsyncComponent(() => import('@/components/forms/UserWithPasswordForm.vue'))
  }

  return forms[type.value.replace(/ /g, '') + 'Form']
})

// methods
function prev() {
  step.value--
}

function next() {
  step.value++
}

function submit() {
  if (step.value === 2) {
    // submit form
    eventBus.emit('submit')
    console.log('submit form')
  } else {
    next()
  }
}

function close() {
  console.log('close')
}
</script>
