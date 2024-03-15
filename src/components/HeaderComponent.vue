<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()
const toHome = () => {
  router.push('/')
}
</script>

<template>
  <div class="p-2 flex justify-between items-center">
    <div @click="toHome()">Cciradih</div>
  </div>
</template>