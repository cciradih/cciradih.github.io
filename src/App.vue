<script setup>
import { RouterView } from 'vue-router'

import Axios from '@/axios'

import HeaderComponent from '@/components/HeaderComponent.vue'
import FooterComponent from '@/components/FooterComponent.vue'

Axios.get('https://raw.githubusercontent.com/cciradih/cciradih/main/2024%E5%B9%B43%E6%9C%8814%E6%97%A5-%E9%9B%AA%E8%8A%B1%E7%AE%97%E6%B3%95.md')
  .then((response) => {
    console.log(response.data)
  })
</script>

<template>
  <div class="flex flex-col justify-between w-screen h-screen bg-[#2F3542] text-[#FFFFFF] overflow-auto">
    <HeaderComponent />
    <RouterView />
    <FooterComponent />
  </div>
  <!-- <img src="@/assets/logo.svg" /> -->
  <!-- <RouterLink to="/">Home</RouterLink>
  <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
  <RouterView /> -->
</template>