-- Equestrian Competition GO — Supabase schema
-- Kør denne fil i Supabase Dashboard → SQL Editor → New query → Run

create extension if not exists "pgcrypto";

-- En "stald" er en gruppe der deler planer
create table if not exists public.stables (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  invite_code text unique not null,
  created_at timestamptz not null default now()
);

-- Én profil-række pr. bruger. stable_id = hvilken stald man er medlem af (max én ad gangen i denne udgave)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  display_name text,
  stable_id uuid references public.stables(id) on delete set null,
  created_at timestamptz not null default now()
);

-- En plan (ét stævne) hører til én stald. steps gemmes som JSON, ligesom i regnearkets kolonne G/B.
create table if not exists public.plans (
  id uuid primary key default gen_random_uuid(),
  stable_id uuid not null references public.stables(id) on delete cascade,
  name text not null default 'Ny stævneplan',
  date date,
  start_time text not null default '14:07',
  steps jsonb not null default '[]'::jsonb,
  created_by uuid references public.profiles(id),
  updated_by uuid references public.profiles(id),
  updated_at timestamptz not null default now()
);

-- Helper: slår den indloggede brugers stable_id op, uden at RLS-policien laver
-- en uendelig selv-reference på profiles-tabellen.
create or replace function public.get_my_stable_id()
returns uuid
language sql
security definer
stable
as $$
  select stable_id from public.profiles where id = auth.uid();
$$;

alter table public.stables enable row level security;
alter table public.profiles enable row level security;
alter table public.plans enable row level security;

-- STABLES: enhver logget ind bruger må slå staldnavn op via invite-kode (for at kunne tilslutte sig),
-- og se sin egen stald.
drop policy if exists "stables_select" on public.stables;
create policy "stables_select" on public.stables
  for select using (auth.role() = 'authenticated');

drop policy if exists "stables_insert" on public.stables;
create policy "stables_insert" on public.stables
  for insert with check (auth.role() = 'authenticated');

-- PROFILES: man må se/opdatere sin egen profil, samt se profiler i samme stald (til visning af navne)
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select using (id = auth.uid() or stable_id = public.get_my_stable_id());

drop policy if exists "profiles_insert" on public.profiles;
create policy "profiles_insert" on public.profiles
  for insert with check (id = auth.uid());

drop policy if exists "profiles_update" on public.profiles;
create policy "profiles_update" on public.profiles
  for update using (id = auth.uid());

-- PLANS: kun synlige/redigerbare for medlemmer af samme stald
drop policy if exists "plans_select" on public.plans;
create policy "plans_select" on public.plans
  for select using (stable_id = public.get_my_stable_id());

drop policy if exists "plans_insert" on public.plans;
create policy "plans_insert" on public.plans
  for insert with check (stable_id = public.get_my_stable_id());

drop policy if exists "plans_update" on public.plans;
create policy "plans_update" on public.plans
  for update using (stable_id = public.get_my_stable_id());

drop policy if exists "plans_delete" on public.plans;
create policy "plans_delete" on public.plans
  for delete using (stable_id = public.get_my_stable_id());

-- Realtime: lad Supabase udsende ændringer på plans, så alle i stalden ser opdateringer live
alter publication supabase_realtime add table public.plans;
