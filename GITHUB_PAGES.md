# GitHub Pages deployment instructions for Geometry Game

1. Go to your repository on GitHub.
2. Click on **Settings** > **Pages**.
3. Under **Source**, select the `main` branch and `/src` folder (where your `index.html` is).
4. Click **Save**.
5. Wait a few minutes. Your site will be available at:
   `https://<your-username>.github.io/<your-repo-name>/`

**Notes:**
- The `.nojekyll` file ensures files in the `src/` folder (like your music) are served correctly.
- All static assets (JS, CSS, images, audio) will be served as-is from `/src`.
- Your site root will be the contents of the `src/` folder.

You are ready to deploy!
