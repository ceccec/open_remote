# GitHub Pages Setup

This repository uses GitHub Actions to automatically deploy VitePress documentation to GitHub Pages.

## Initial Setup

1. **Enable GitHub Pages**:
   - Go to your repository Settings → Pages
   - Under "Source", select "GitHub Actions"
   - Save the settings

2. **Configure Permissions** (if needed):
   - Go to Settings → Actions → General
   - Under "Workflow permissions", ensure "Read and write permissions" is selected
   - Check "Allow GitHub Actions to create and approve pull requests"

## How It Works

The `.github/workflows/docs.yml` workflow:

1. **Triggers** on:
   - Push to `main` branch (when docs/app/spec files change)
   - Manual workflow dispatch

2. **Builds**:
   - Generates documentation from Rails components and tests
   - Builds VitePress site with correct base path for GitHub Pages
   - Outputs to `docs/.vitepress/dist`

3. **Deploys**:
   - Uploads build artifact
   - Deploys to GitHub Pages
   - Documentation available at: `https://<username>.github.io/<repository-name>/`

## Base Path Configuration

The documentation generator automatically detects the deployment environment:

- **GitHub Actions**: Base path is `/<repository-name>/`
- **Local development**: Base path is `/` (root)

This is handled automatically via environment variables:
- `GITHUB_REPOSITORY` - Used to determine repository name
- `GITHUB_ACTIONS` - Set to `"true"` in GitHub Actions environment

## Troubleshooting

### Documentation not deploying

1. Check Actions tab for workflow failures
2. Verify GitHub Pages is enabled (Settings → Pages)
3. Ensure workflow has correct permissions
4. Check that `docs/package.json` exists and has VitePress dependency

### Wrong base path

If links are broken, verify:
- Base path matches repository name
- Config is regenerated on each build
- No hardcoded paths in markdown files

### Build failures

Common issues:
- Missing Node.js dependencies: Run `npm ci` in `docs/` directory
- Ruby dependencies: Ensure `bundle install` completes
- Database not needed: Documentation generation doesn't require a database

## Manual Deployment

To manually trigger deployment:

1. Go to Actions tab
2. Select "Deploy Documentation" workflow
3. Click "Run workflow"
4. Select branch (usually `main`)
5. Click "Run workflow" button
