-- Execute no SQL Editor do seu projeto Supabase.
-- Cada usuário autenticado acessa somente seus próprios registros.
create table if not exists public.sistema_dados (
  user_id uuid primary key references auth.users(id) on delete cascade,
  dados jsonb not null default '{"ingredients":[],"moves":[],"finances":[]}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.sistema_dados enable row level security;
create policy "ler dados proprios" on public.sistema_dados for select to authenticated using ((select auth.uid()) = user_id);
create policy "inserir dados proprios" on public.sistema_dados for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "atualizar dados proprios" on public.sistema_dados for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
