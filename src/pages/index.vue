<template>
  <core-layout :title="$t('Users.Page.title')">
    <v-data-table
      :headers="headers"
      :items="users"
      :loading="loading"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-spacer></v-spacer>

          <v-btn
            class="mb-2"
            color="primary"
            @click="showAddUser = true"
          >
            + User
          </v-btn>

        </v-toolbar>
      </template>

      <template v-slot:item.actions="{ item }">
        <v-icon
          class="me-2"
          size="small"
          @click="editItem(item)"
        >
          mdi-pencil
        </v-icon>
        <v-icon
          size="small"
          @click="deleteItem(item)"
        >
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>

    <add-user-dialog
      v-if="showAddUser"
      v-model="showAddUser"
      @submit:form="addUser"
    />

    <edit-user-dialog
      v-if="showEditUser"
      v-model="showEditUser"
      :user="userToEdit"
      @submit="updateUser"
    />

  </core-layout>
</template>

<script setup>
// vue
import { ref, defineAsyncComponent } from 'vue'
// components
import CoreLayout from '@/layouts/CoreLayout'
// utils
import { headers } from '@/utils/users'
import { usersResponse } from '@/mock/usersResponse'
// async components
const AddUserDialog = defineAsyncComponent(() => import('@/components/dialogs/AddUserDialog'))
const EditUserDialog = defineAsyncComponent(() => import('@/components/dialogs/EditUserDialog'))

const loading = ref(false)
const users = ref([])
const userToEdit = ref(null)

const showAddUser = ref(false)
const showEditUser = ref(false)

// methods
function addUser(user) {
  users.value.push(user)
}

function updateUser(user) {
  const index = users.value.findIndex(u => u.id === user.id)
  users.value[index] = user
}

function editItem(user) {
  userToEdit.value = user
  showEditUser.value = true
}

function deleteItem(item) {
  users.value = users.value.filter(user => user.id !== item.id)
}

// initialization
async function fetchItems() {
  loading.value = true

  const response = await new Promise(resolve => {
    setTimeout(() => { resolve(usersResponse) }, 2000)
  })

  loading.value = false
  users.value = response
}
fetchItems()
</script>
