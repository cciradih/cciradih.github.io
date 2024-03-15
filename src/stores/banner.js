import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useBannerStore = defineStore('banner', () => {
    const banner = ref({})
    const getBanner = computed(() => banner.value)
    const setBanner = (value) => {
        banner.value = value
    }
    return { banner, getBanner, setBanner }
})