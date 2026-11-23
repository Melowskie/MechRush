-- MechRush leaderboard: run this once in Supabase > SQL Editor > New query > Run.

create table if not exists public.leaderboard (
  id          bigint generated always as identity primary key,
  player_name text        not null,
  score       integer     not null,
  created_at  timestamptz not null default now(),

  -- basic validation (also enforced for every insert, even from outside the website)
  constraint leaderboard_name_length check (char_length(player_name) between 2 and 20),
  constraint leaderboard_name_trimmed check (player_name = btrim(player_name)),
  constraint leaderboard_name_chars  check (player_name !~ '[<>]'),
  constraint leaderboard_score_range check (score between 0 and 25000)
);

create index if not exists leaderboard_top_idx
  on public.leaderboard (score desc, created_at asc);

alter table public.leaderboard enable row level security;

-- Start clean so the script can be re-run safely.
drop policy if exists "Public can read leaderboard" on public.leaderboard;
drop policy if exists "Public can submit scores"    on public.leaderboard;

-- Anyone can read the scores.
create policy "Public can read leaderboard"
  on public.leaderboard for select
  to anon, authenticated
  using (true);

-- Anyone can add a score, but only a valid one.
create policy "Public can submit scores"
  on public.leaderboard for insert
  to anon, authenticated
  with check (
    char_length(player_name) between 2 and 20
    and player_name = btrim(player_name)
    and player_name !~ '[<>]'
    and score between 0 and 25000
  );

-- No UPDATE or DELETE policies exist, so the public cannot edit or remove rows.
revoke all on public.leaderboard from anon, authenticated;
grant select, insert on public.leaderboard to anon, authenticated;
