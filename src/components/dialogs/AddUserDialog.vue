<template>
  <v-dialog v-model="show">
    <v-stepper v-model="step">
      <v-stepper-header>
        <v-stepper-item
          :complete="step > 1"
          step="1"
          :value="1"
        >
          <!-- {{ $t('DMS.Stepper.selectDmsType') }} -->
        </v-stepper-item>

        <v-divider />
        <v-stepper-item
          :complete="step > 2"
          step="2"
          :value="2"
        >
          <!-- {{ $t('DMS.Stepper.addDms') }} -->
        </v-stepper-item>
      </v-stepper-header>

      <v-stepper-window>
        <v-stepper-window-item :value="1">
          <!-- <dms-type-form v-model="form.dmsType" /> -->
        </v-stepper-window-item>

        <v-stepper-window-item :value="2">
          <!-- <component -->
          <!--   :is="nextStepForm" -->
          <!--   :event-bus="eventBus" -->
          <!--   :update-with="props.updateWith" -->
          <!--   :create-with="props.createWith" -->
          <!--   @close:dialog="close" -->
          <!--   @submit:form="submit" -->
          <!-- /> -->
        </v-stepper-window-item>
      </v-stepper-window>

      <!-- <stepper-actions -->
      <!--   :show-back="form.step > 1" -->
      <!--   :submit-text="form.step === 2 ? $t('Buttons.submit') : $t('Buttons.continue')" -->
      <!--   @back="prev" -->
      <!--   @cancel="form.step === 2 ? emitClose() : close()" -->
      <!--   @submit="form.step === 2 ? emitSubmit() : next()" -->
      <!-- /> -->
    </v-stepper>
  </v-dialog>
</template>

<script setup>
import { ref, computed, defineAsyncComponent } from 'vue'

const props = defineProps({ dialog: Boolean })

// constants
const types = [
  'Admin',
  'User'
]

// refs
const step = ref(1)
// computeds
const show = computed({
  get: () => props.dialog,
  set: value => emit('update:dialog', value)
})
</script>
