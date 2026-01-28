import { defineConfig } from 'vite'
import { resolve } from 'path'

export default defineConfig({
  // Configure cache directory to use Rails tmp/ directory (already ignored by git)
  cacheDir: resolve(__dirname, '../tmp/vitepress-cache'),
  // Configure temp directory for Vite build
  build: {
    outDir: '.vitepress/dist',
  },
  // Server options
  server: {
    fs: {
      // Allow serving files from project root
      allow: ['..']
    }
  }
})
