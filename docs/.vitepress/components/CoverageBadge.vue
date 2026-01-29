<template>
  <span class="coverage-badge" :class="coverageClass">
    <span class="coverage-icon">{{ coverageIcon }}</span>
    <span class="coverage-text">{{ coverageText }}</span>
  </span>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  coverage: {
    type: Number,
    required: true,
    validator: (value) => value >= 0 && value <= 100
  },
  threshold: {
    type: Number,
    default: 100
  }
})

const coverageClass = computed(() => {
  if (props.coverage >= props.threshold) return 'coverage-excellent'
  if (props.coverage >= 80) return 'coverage-good'
  if (props.coverage >= 50) return 'coverage-warning'
  return 'coverage-poor'
})

const coverageIcon = computed(() => {
  if (props.coverage >= props.threshold) return '✓'
  if (props.coverage >= 80) return '◐'
  if (props.coverage >= 50) return '⚠'
  return '✗'
})

const coverageText = computed(() => {
  return `${props.coverage}% Coverage`
})
</script>

<style scoped>
.coverage-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.875rem;
  font-weight: 500;
}

.coverage-excellent {
  background: var(--vp-c-success-soft);
  color: var(--vp-c-success-1);
}

.coverage-good {
  background: var(--vp-c-tip-soft);
  color: var(--vp-c-tip-1);
}

.coverage-warning {
  background: var(--vp-c-warning-soft);
  color: var(--vp-c-warning-1);
}

.coverage-poor {
  background: var(--vp-c-danger-soft);
  color: var(--vp-c-danger-1);
}

.coverage-icon {
  font-weight: bold;
}
</style>
