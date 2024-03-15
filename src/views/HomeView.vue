<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { marked } from 'marked'

const html = marked.parse('# Marked in Node.js\n\nRendered by **marked**.');

const article = ref({
  id: 0,
  title: '修复梯子',
  classificationId: 0,
  classificationName: '网络',
  digest: '传统的 shadowsocks 已经很容易被当下的各种手段检测而导致垮掉，不得已只能全面转为 Vmess + Websocket + TLS 伪装。这个在前几年的备用方案已是目前的唯一解。',
  createTime: '2024年2月29日',
  readingTime: '6'
})
const router = useRouter()
const toArticle = (id) => {
  router.push('/article/' + id)
}
</script>

<template>
  <div class="px-8 flex flex-col gap-8">
    <div class="flex flex-col gap-2">
      <div class="text-3xl text-[#747d8c]">最新文章</div>
      <div class="flex flex-col gap-1">
        <div class="flex gap-1 text-xs text-[#a4b0be]">
          <div>{{ article.createTime }}</div>
          <div>
            {{ article.classificationName }}
          </div>
          <div>{{ article.readingTime }}分钟</div>
        </div>
        <div class="text-xl" @click="toArticle(article.id)">{{ article.title }}</div>
        <div class="line-clamp-2">{{ article.digest }}</div>
      </div>
    </div>
    <div class="flex flex-col gap-2">
      <div class="text-3xl text-[#747d8c]">分类</div>
      <div class="flex gap-1">
        <div>网络</div>
        <div>编程</div>
      </div>
    </div>
    <div class="flex flex-col gap-2">
      <div class="text-3xl text-[#747d8c]">关于</div>
      <div>{{ html }}</div>
      <div class="prose" v-html="html"></div>
    </div>
  </div>
</template>
