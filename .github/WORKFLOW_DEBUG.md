# GitHub Pages Workflow Debug Guide

## Common Issues and Solutions

### 1. Database Connection Failures

**Symptoms:**
- Error: `could not connect to server`
- Rails fails to load environment

**Debug Steps:**
- Check PostgreSQL service is running (should show in workflow logs)
- Verify `DATABASE_URL` matches service configuration
- Check if database creation step completed

**Solution:**
- The workflow includes PostgreSQL service with health checks
- Database setup uses `|| true` to continue if database exists
- Check logs for "Database may already exist" message

### 2. Documentation Generation Failures

**Symptoms:**
- `bundle exec rake docs:from_tests` fails
- Missing VitePress config file

**Debug Steps:**
- Check if Rails environment loads successfully
- Verify all required gems are installed
- Check if `docs/.vitepress/config.js` is generated
- Look for error messages about missing classes or files

**Solution:**
- Ensure all dependencies are in Gemfile
- Check that `lib/tasks/docs_generator.rb` is accessible
- Verify `GITHUB_REPOSITORY` and `GITHUB_ACTIONS` env vars are set

### 3. VitePress Build Failures

**Symptoms:**
- `npm run build` fails
- Missing `docs/.vitepress/dist` directory

**Debug Steps:**
- Check if `docs/package.json` exists and has VitePress dependency
- Verify `docs/.vitepress/config.js` is valid JavaScript
- Check for syntax errors in generated config
- Verify base path is correct for repository

**Solution:**
- Base path should be `/open_remote/` for repository `ceccec/open_remote`
- Output directory should be `.vitepress/dist` (relative to `docs/`)
- Check config file syntax if build fails

### 4. Artifact Upload Failures

**Symptoms:**
- "Path does not exist" error
- Empty artifact

**Debug Steps:**
- Verify `docs/.vitepress/dist` exists after build
- Check build step completed successfully
- List directory contents: `ls -la docs/.vitepress/dist`

**Solution:**
- Ensure VitePress build completed without errors
- Check output directory path matches workflow upload path
- Verify files were generated in dist directory

### 5. Base Path Issues

**Symptoms:**
- Links broken on GitHub Pages
- Assets not loading
- 404 errors for pages

**Debug Steps:**
- Check generated `docs/.vitepress/config.js` base path
- Verify it matches repository name: `/open_remote/`
- Check if GitHub Pages is configured correctly

**Solution:**
- Base path should be `/{repository-name}/` for project pages
- For user/organization pages, base path should be `/`
- Repository name is extracted from `GITHUB_REPOSITORY` env var

## Workflow Steps Checklist

When debugging, verify each step completes:

1. ✅ **Checkout code** - Code is checked out
2. ✅ **Set up Ruby** - Ruby version detected, gems installed
3. ✅ **Set up Node.js** - Node.js 20 installed
4. ✅ **Install docs dependencies** - `npm ci` completes in `docs/`
5. ✅ **Set up database** - PostgreSQL accessible, schema loaded
6. ✅ **Generate documentation** - `docs/.vitepress/config.js` created
7. ✅ **Build VitePress** - `docs/.vitepress/dist` directory created
8. ✅ **Upload artifact** - Artifact contains dist files
9. ✅ **Deploy to GitHub Pages** - Deployment succeeds

## Environment Variables

The workflow sets these environment variables:

- `RAILS_ENV=test` - Rails environment
- `DATABASE_URL=postgres://postgres:postgres@localhost:5432/open_remote_test` - Database connection
- `GITHUB_REPOSITORY=${{ github.repository }}` - Repository name (e.g., `ceccec/open_remote`)
- `GITHUB_ACTIONS=true` - Indicates running in GitHub Actions

## Manual Testing

To test locally before pushing:

```bash
# Set environment variables
export GITHUB_REPOSITORY="ceccec/open_remote"
export GITHUB_ACTIONS="true"
export RAILS_ENV=test
export DATABASE_URL=postgres://postgres:postgres@localhost:5432/open_remote_test

# Generate docs
bundle exec rake docs:from_tests

# Build VitePress
cd docs
npm run build

# Check output
ls -la .vitepress/dist
```

## GitHub Pages Configuration

Ensure GitHub Pages is configured:

1. Go to repository Settings → Pages
2. Source: Select "GitHub Actions"
3. Save settings
4. Workflow will deploy automatically

## Viewing Workflow Logs

1. Go to repository → Actions tab
2. Click on "Deploy Documentation" workflow
3. Click on the latest run
4. Expand each step to see detailed logs
5. Look for error messages or warnings

## Quick Fixes

- **Workflow not triggering**: Check path filters in workflow file
- **Build fails**: Check Node.js version matches `package.json`
- **Database errors**: Verify PostgreSQL service is running
- **Missing files**: Check file paths are correct (relative to repo root)
