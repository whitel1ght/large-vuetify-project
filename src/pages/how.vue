<template>
  <div class="wrapper">
    <h1 class="text-center">HOW</h1>

    <v-carousel v-model="model">
      <v-carousel-item
        v-for="(slide, i) in slides"
        :key="slide.title"
        :value="i"
      >
        <v-sheet
          height="100%"
          tile
        >
          <div class="d-flex flex-column fill-height justify-center align-center">
            <div
              v-if="slide.text"
              v-html="slide.text"
            >
            </div>

            <ul v-if="slide.list">
              <li v-for="item in slide.list" :key="item">{{ item }}</li>
            </ul>
          </div>
        </v-sheet>
      </v-carousel-item>
    </v-carousel>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const model = ref(0)

const slides = [
  {
    title: 'HOW',
    text: `
      <p><b>TLDR;</b> Think not only WHAT are you doing but HOW you're doing it.</p>
      <p>It involves considering the manner in which you approach and execute your actions, as this can greatly impact the quality of your work and the overall outcome.</p>
      <p> By paying attention to both the “WHAT” and the “HOW”, you can refine your processes, identify areas for improvement, and ultimately achieve greater success in your endeavors.</p>
    `,
  },
  {
    title: 'HOW',
    list: [
      '🧨  Create your own tools and workflows',
      '🔧  Know your tools and learn new ones',
      '🔮  Focus on the process, not just the outcome',
      '❓  Question everything',
    ],
  },
]
</script>

<style lang="scss">
.wrapper {
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 800px;
  margin: auto auto;
  height: 100%;

  .v-window__controls {
    display: none !important;
  }

  .v-carousel__controls {
    background-color: transparent;
  }

  li {
    font-size: 1.5rem;
  }

  p {
    margin: 8px 0;
    font-size: 1.5rem;
  }
}
</style>
