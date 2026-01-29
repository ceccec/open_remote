<template>
  <div class="method-coverage" v-if="coverage">
    <div class="coverage-header">
      <h4>Test Coverage</h4>
      <CoverageBadge :coverage="coverage.coverage_percentage" />
    </div>
    
    <div class="coverage-details">
      <div class="coverage-stats">
        <span>Covered: {{ coverage.covered_lines.length }} lines</span>
        <span v-if="coverage.uncovered_lines.length > 0">
          Uncovered: {{ coverage.uncovered_lines.length }} lines
        </span>
      </div>
      
      <div v-if="coverage.uncovered_lines.length > 0" class="uncovered-lines">
        <details>
          <summary>Show uncovered lines</summary>
          <ul>
            <li v-for="line in coverage.uncovered_lines" :key="line">
              Line {{ line }}
            </li>
          </ul>
        </details>
      </div>
    </div>
  </div>
</template>

<script setup>
import CoverageBadge from './CoverageBadge.vue'

defineProps({
  coverage: {
    type: Object,
    default: null
  }
})
</script>

<style scoped>
.method-coverage {
  margin: 1rem 0;
  padding: 1rem;
  background: var(--vp-c-bg-soft);
  border-radius: 6px;
  border-left: 3px solid var(--vp-c-brand-1);
}

.coverage-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.coverage-header h4 {
  margin: 0;
  font-size: 1rem;
}

.coverage-details {
  font-size: 0.875rem;
  color: var(--vp-c-text-2);
}

.coverage-stats {
  display: flex;
  gap: 1rem;
  margin-bottom: 0.5rem;
}

.uncovered-lines {
  margin-top: 0.5rem;
}

.uncovered-lines ul {
  margin: 0.5rem 0 0 1.5rem;
  padding: 0;
}

.uncovered-lines li {
  font-family: var(--vp-font-family-mono);
  font-size: 0.8rem;
}
</style>
