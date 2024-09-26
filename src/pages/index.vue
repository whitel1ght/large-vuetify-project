<template>
  <core-layout :title="$t('Users.Page.title')">
    <!-- <x-table /> -->
  </core-layout>
</template>

<script setup>
// vue
import { ref } from 'vue'
// components
import CoreLayout from '@/layouts/CoreLayout.vue'
// utils
import { headers } from '@/utils/users'

const items = ref([])

// initialization
async function fetchItems() {
  const response = await new Promise(resolve => {
    setTimeout(() => {
      resolve([
        {
          id: 1,
          name: 'John Doe',
          email: '',
          role: 'Admin'
        },
        {
          id: 2,
          name: 'Jane Doe',
          email: '',
          role: 'User'
        }
      ])
    }, 3000)
  })
  console.log(response)
  items.value = response
}

fetchItems()
</script>
