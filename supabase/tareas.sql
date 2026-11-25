-- Temas varios (lista de tareas) de Martona United
create table if not exists public.tareas (
  id           text primary key,
  titulo       text not null,
  descripcion  text,
  responsable  text,                 -- 'p:<id de jugador>' o 'o:<nombre libre>'
  hecha        boolean not null default false,
  hecha_at     timestamptz,
  creada       timestamptz not null default now()
);

alter table public.tareas enable row level security;
drop policy if exists "leer"   on public.tareas;
drop policy if exists "crear"  on public.tareas;
drop policy if exists "editar" on public.tareas;
drop policy if exists "borrar" on public.tareas;
create policy "leer"   on public.tareas for select to anon using (true);
create policy "crear"  on public.tareas for insert to anon with check (true);
create policy "editar" on public.tareas for update to anon using (true) with check (true);
create policy "borrar" on public.tareas for delete to anon using (true);

do $$ begin
  alter publication supabase_realtime add table public.tareas;
exception when duplicate_object then null; end $$;
