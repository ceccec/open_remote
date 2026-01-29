<template>
  <div class="method-card">
    <div class="method-header">
      <h3 class="method-name">
        <code>{{ method.name }}</code>
        <Badge v-if="method.visibility" :type="method.visibility === 'public' ? 'tip' : 'warning'" :text="method.visibility" />
        <Badge v-if="method.test_status === 'passing'" type="success" text="✓ Tested" />
      </h3>
      <div class="method-signature">
        <code class="signature">{{ method.signature }}</code>
      </div>
    </div>

    <div v-if="method.description" class="method-description">
      {{ method.description }}
    </div>

    <div v-if="method.parameters && method.parameters.length" class="method-parameters">
      <h4>Parameters</h4>
      <table class="params-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Description</th>
            <th>Default</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="param in method.parameters" :key="param.name">
            <td><code>{{ param.name }}</code></td>
            <td><code>{{ param.type }}</code></td>
            <td>{{ param.description }}</td>
            <td><code v-if="param.default">{{ param.default }}</code></td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="method.returns" class="method-returns">
      <h4>Returns</h4>
      <div class="return-info">
        <code>{{ method.returns.type }}</code>
        <span v-if="method.returns.description"> - {{ method.returns.description }}</span>
      </div>
    </div>

    <div v-if="method.examples && method.examples.length" class="method-examples">
      <h4>Examples</h4>
      <Tabs>
        <Tab v-for="(example, index) in method.examples" :key="index" :label="example.title">
          <div class="example-code">
            <pre><code class="language-ruby">{{ example.code }}</code></pre>
          </div>
          <div class="example-meta">
            <Badge type="tip" :text="`✓ ${example.test_status}`" />
            <small>
              <a :href="example.source_link" target="_blank">Source: {{ example.source_file }}</a>
            </small>
          </div>
        </Tab>
      </Tabs>
    </div>

    <div v-if="method.related_methods && method.related_methods.length" class="method-related">
      <h4>Related Methods</h4>
      <ul>
        <li v-for="related in method.related_methods" :key="related">
          <a :href="related.link">{{ related.name }}</a>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { Badge, Tabs, Tab } from 'vitepress'

defineProps({
  method: {
    type: Object,
    required: true
  }
})
</script>

<style scoped>
.method-card {
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  padding: 1.5rem;
  margin: 1.5rem 0;
  background: var(--vp-c-bg-soft);
}

.method-header {
  margin-bottom: 1rem;
}

.method-name {
  font-size: 1.5rem;
  margin: 0 0 0.5rem 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.method-signature {
  font-family: var(--vp-font-family-mono);
  font-size: 0.9rem;
  color: var(--vp-c-text-2);
}

.signature {
  background: var(--vp-c-bg-alt);
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
}

.method-description {
  margin: 1rem 0;
  line-height: 1.6;
}

.params-table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
}

.params-table th,
.params-table td {
  padding: 0.5rem;
  text-align: left;
  border-bottom: 1px solid var(--vp-c-divider);
}

.params-table th {
  font-weight: 600;
  background: var(--vp-c-bg-alt);
}

.method-returns {
  margin: 1rem 0;
}

.return-info {
  padding: 0.5rem;
  background: var(--vp-c-bg-alt);
  border-radius: 4px;
}

.method-examples {
  margin: 1.5rem 0;
}

.example-code {
  margin: 1rem 0;
}

.example-meta {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 0.5rem;
}

.method-related ul {
  list-style: none;
  padding: 0;
  margin: 0.5rem 0;
}

.method-related li {
  padding: 0.25rem 0;
}
</style>
