-- Mount View School CMS schema
create extension if not exists pgcrypto;

create table if not exists public.site_settings (
  id uuid primary key default gen_random_uuid(),
  school_name text not null,
  address text,
  phone text,
  email text,
  logo_url text,
  updated_at timestamptz default now()
);

create table if not exists public.pages (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  content text default '',
  seo_title text,
  seo_description text,
  published boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  content text default '',
  cover_url text,
  published_at date,
  published boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.slides (
  id uuid primary key default gen_random_uuid(),
  title text,
  subtitle text,
  image_url text not null,
  sort_order integer default 0,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.gallery_items (
  id uuid primary key default gen_random_uuid(),
  title text,
  image_url text not null,
  category text,
  created_at timestamptz default now()
);

create table if not exists public.team_members (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  designation text,
  photo_url text,
  bio text,
  sort_order integer default 0,
  created_at timestamptz default now()
);

create index if not exists posts_published_at_idx on public.posts(published_at desc);
create index if not exists pages_slug_idx on public.pages(slug);

alter table public.site_settings enable row level security;
alter table public.pages enable row level security;
alter table public.posts enable row level security;
alter table public.slides enable row level security;
alter table public.gallery_items enable row level security;
alter table public.team_members enable row level security;

-- Public visitors can read published/public content.
create policy "public read settings" on public.site_settings for select using (true);
create policy "public read pages" on public.pages for select using (published = true);
create policy "public read posts" on public.posts for select using (published = true);
create policy "public read slides" on public.slides for select using (active = true);
create policy "public read gallery" on public.gallery_items for select using (true);
create policy "public read team" on public.team_members for select using (true);

-- CMS access: keep Supabase Auth sign-ups disabled and create only trusted admin users.
create policy "authenticated manage settings" on public.site_settings for all to authenticated using (true) with check (true);
create policy "authenticated manage pages" on public.pages for all to authenticated using (true) with check (true);
create policy "authenticated manage posts" on public.posts for all to authenticated using (true) with check (true);
create policy "authenticated manage slides" on public.slides for all to authenticated using (true) with check (true);
create policy "authenticated manage gallery" on public.gallery_items for all to authenticated using (true) with check (true);
create policy "authenticated manage team" on public.team_members for all to authenticated using (true) with check (true);

insert into public.site_settings (school_name,address,phone,email)
select 'Mount View Secondary Boarding School','Ghorahi-18, Rajhena, Dang','082-561310','info@mountviewschool.edu.np'
where not exists (select 1 from public.site_settings);

-- Storage bucket for CMS images.
insert into storage.buckets (id,name,public)
values ('school-media','school-media',true)
on conflict (id) do nothing;

create policy "public read school media" on storage.objects for select using (bucket_id='school-media');
create policy "authenticated upload school media" on storage.objects for insert to authenticated with check (bucket_id='school-media');
create policy "authenticated update school media" on storage.objects for update to authenticated using (bucket_id='school-media');
create policy "authenticated delete school media" on storage.objects for delete to authenticated using (bucket_id='school-media');
