// Auto-discovery sidebar generator following Zeitwerk architecture
// Zeitwerk maps file paths directly to class/module names:
// - app/models/asset/references.rb → Asset::References
// - app/models/data_point/analytics.rb → DataPoint::Analytics
// - Directories represent namespaces, files represent classes/modules
// This sidebar generator mirrors Zeitwerk's structure for documentation

import { readdirSync, statSync, readFileSync, existsSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const docsRoot = join(__dirname, '..')

function getTitleFromFrontmatter(filePath) {
  try {
    const content = readFileSync(filePath, 'utf-8')
    const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---/)
    if (frontmatterMatch) {
      const titleMatch = frontmatterMatch[1].match(/^title:\s*(.+)$/m)
      if (titleMatch) {
        return titleMatch[1].trim().replace(/^["']|["']$/g, '')
      }
    }
  } catch (e) {
    // Ignore errors
  }
  return null
}

function getTitleFromFilename(filePath, parentNamespace = '') {
  const name = filePath.split('/').pop().replace(/\.md$/, '')
  
  // Convert snake_case to CamelCase (Zeitwerk convention)
  // snake_case → CamelCase (e.g., "data_point" → "DataPoint")
  const camelCase = name
    .split('_')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join('')
  
  // If we have a parent namespace, use Zeitwerk namespace notation (::)
  // parentNamespace is already in CamelCase format (e.g., "Asset", "DataPoint")
  if (parentNamespace) {
    // Zeitwerk: nested modules use :: notation
    return `${parentNamespace}::${camelCase}`
  }
  
  // Top-level class/module
  return camelCase
}

function scanDirectory(dir, basePath = '', parentName = '') {
  const items = []
  
  try {
    const entries = readdirSync(dir, { withFileTypes: true })
    
    // Separate directories and files, excluding hidden/system files
    const dirs = entries
      .filter(e => e.isDirectory() && !e.name.startsWith('.') && e.name !== 'node_modules')
      .sort((a, b) => a.name.localeCompare(b.name))
    
    const mdFiles = entries
      .filter(e => e.isFile() && e.name.endsWith('.md') && e.name !== 'index.md')
      .sort((a, b) => a.name.localeCompare(b.name))
    
    // Process markdown files first (Zeitwerk: files represent classes/modules)
    for (const entry of mdFiles) {
      const filePath = join(dir, entry.name)
      const fileName = entry.name.replace(/\.md$/, '')
      const linkPath = basePath ? `/${basePath}/${fileName}` : `/${fileName}`
      
      // Build full path for Zeitwerk namespace resolution
      const fullNamespacePath = basePath ? `${basePath}/${fileName}` : fileName
      
      // Convert fileName to CamelCase for Zeitwerk namespace
      const parentCamelCase = parentName
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join('')
      
      // Get title from frontmatter, or generate from filename using Zeitwerk conventions
      const title = getTitleFromFrontmatter(filePath) || 
                    getTitleFromFilename(entry.name, parentCamelCase || '')
      
      // Check if there's a subdirectory with the same name (Zeitwerk: nested modules)
      const subDirPath = join(dir, fileName)
      let subItems = []
      
      if (existsSync(subDirPath) && statSync(subDirPath).isDirectory()) {
        // Scan subdirectory for nested modules (Zeitwerk namespace)
        // Pass the CamelCase namespace for proper :: notation
        const childNamespace = fileName
          .split('_')
          .map(word => word.charAt(0).toUpperCase() + word.slice(1))
          .join('')
        const fullNamespace = parentCamelCase ? `${parentCamelCase}::${childNamespace}` : childNamespace
        subItems = scanDirectory(subDirPath, `${basePath}/${fileName}`, fullNamespace)
      }
      
      if (subItems.length > 0) {
        // File has subdirectory with nested modules (Zeitwerk: parent module with nested modules)
        items.push({
          text: title,
          link: linkPath,
          items: subItems,
          collapsed: false
        })
      } else {
        // Just a regular class/module (Zeitwerk: single class)
        items.push({
          text: title,
          link: linkPath
        })
      }
    }
    
    // Process directories that don't have a corresponding .md file
    for (const entry of dirs) {
      const dirName = entry.name
      const dirPath = join(dir, dirName)
      const mdFilePath = join(dir, `${dirName}.md`)
      
      // Skip if we already processed this as a file with subdirectory
      if (mdFiles.some(f => f.name === `${dirName}.md`)) {
        continue
      }
      
      // Check if directory has an index.md
      const indexPath = join(dirPath, 'index.md')
      const subPath = basePath ? `${basePath}/${dirName}` : dirName
      
      // Convert dirName to CamelCase for Zeitwerk namespace
      const dirCamelCase = dirName
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join('')
      const fullNamespace = parentName
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join('')
      const namespaceForDir = fullNamespace ? `${fullNamespace}::${dirCamelCase}` : dirCamelCase
      
      if (existsSync(indexPath)) {
        // Index file exists - use its title or generate from namespace
        const indexTitle = getTitleFromFrontmatter(indexPath) || namespaceForDir
        const subItems = scanDirectory(dirPath, subPath, namespaceForDir)
        
        items.push({
          text: indexTitle,
          link: `/${subPath}`,
          items: subItems.length > 0 ? subItems : undefined,
          collapsed: false
        })
      } else {
        // Directory without index.md - Zeitwerk: namespace directory
        // Scan it for nested modules/classes
        const subItems = scanDirectory(dirPath, subPath, namespaceForDir)
        if (subItems.length > 0) {
          const dirTitle = namespaceForDir
          items.push({
            text: dirTitle,
            link: `/${subPath}`,
            items: subItems,
            collapsed: false
          })
        }
      }
    }
  } catch (e) {
    // Directory doesn't exist or can't be read
    console.warn(`Warning: Could not scan directory ${dir}:`, e.message)
  }
  
  return items
}

export function generateSidebar() {
  const sidebar = {}
  
  // Root sidebar
  sidebar['/'] = [
    {
      text: 'Getting Started',
      collapsed: true,
      items: [
        { text: 'Home', link: '/' },
        { text: 'Testing Experience', link: '/testing-ux' }
      ]
    }
  ]
  
  // Auto-discover sidebars for each section
  const sections = ['api/models', 'api/controllers', 'api/services', 'api/jobs', 'api/concerns', 'examples']
  
  for (const section of sections) {
    const sectionPath = join(docsRoot, section)
    try {
      if (existsSync(sectionPath) && statSync(sectionPath).isDirectory()) {
        const items = scanDirectory(sectionPath, section)
        if (items.length > 0) {
          sidebar[`/${section}/`] = items
        }
      }
    } catch (e) {
      // Section doesn't exist, skip
      console.warn(`Warning: Section ${section} not found:`, e.message)
    }
  }
  
  return sidebar
}
