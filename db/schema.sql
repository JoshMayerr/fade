create extension if not exists "pgcrypto";

create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  share_id text unique not null,
  write_token text unique not null,
  display_name text null,
  start_at timestamptz null,
  created_at timestamptz not null default now()
);

create table if not exists invites (
  code text primary key,
  inviter_profile_id uuid not null references profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null,
  used_by uuid references profiles(id),
  used_at timestamptz null
);

create table if not exists friends (
  user_id uuid not null references profiles(id) on delete cascade,
  friend_id uuid not null references profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, friend_id)
);
