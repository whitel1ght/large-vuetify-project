<template>
  <v-layout class="rounded rounded-md fill-height">
    <v-navigation-drawer>
      <v-list>
        <v-list-item title="Navigation drawer"></v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar title="Application bar"></v-app-bar>

    <v-main class="d-flex flex-column align-center justify-center" style="min-height: 300px;">
      <h2>Table example</h2>
      <x-table />
    </v-main>
  </v-layout>
</template>

<script setup>
import XTable from '@/components/Table.vue'

</script>
