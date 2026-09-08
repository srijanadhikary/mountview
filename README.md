# Mount View School — GitHub + Vercel + Supabase CMS

This project redesigns the supplied Mount View website while migrating its existing public pages/news into an editable Supabase CMS.

## Stack
- React + Vite
- Supabase PostgreSQL + Auth + Storage
- Vercel
- GitHub

## 1. Create Supabase project
Create a project at Supabase and open **SQL Editor**.

Run:
1. `supabase/schema.sql`
2. `supabase/seed.sql`

The seed file contains the migrated content from the supplied website export.

## 2. Create the administrator
In Supabase:
**Authentication → Users → Add user**

Create your administrator email/password.

For security, keep public sign-ups disabled. The CMS uses Supabase Auth and the database policies allow write access only to authenticated users.

## 3. Local setup
Install Node.js LTS.

```bash
npm install
```

Create `.env.local`:

```env
VITE_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

Then:

```bash
npm run dev
```

## 4. GitHub + Vercel
Push this project to GitHub.

In Vercel, import the GitHub repository and add:

- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

Build command:
`npm run build`

Output directory:
`dist`

Vercel normally detects Vite automatically.

## 5. CMS
Open:

`/admin`

The CMS currently supports:
- News & Events
- Pages
- Homepage slider
- Gallery
- Team

You can add/edit/delete content without editing the source code.

## 6. Images
The supplied website images are included in `public/assets` so the first deployment works without migrating every existing image to Supabase Storage.

For new CMS uploads, use the `school-media` bucket created by `schema.sql`. The next enhancement can add a visual upload button directly into the CMS editor.

## Important security note
Never put the Supabase **service_role** key in Vercel frontend environment variables or in GitHub. Only the public `anon` key belongs in the frontend.
