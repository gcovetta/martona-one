-- La Martona One · Más 40
-- Pegar completo en Supabase → SQL Editor → Run.

create table if not exists public.jugadores (
  id          text primary key,
  name        text not null,
  num         int,
  ideal       text,
  alt1        text,
  alt2        text,
  photo       text,              -- foto chica (200px) como data URL
  inj         boolean not null default false,
  inj_weeks   int,
  inj_since   timestamptz,
  updated_at  timestamptz not null default now()
);

create or replace function public.touch_updated_at() returns trigger
language plpgsql as $$ begin new.updated_at = now(); return new; end $$;

drop trigger if exists jugadores_touch on public.jugadores;
create trigger jugadores_touch before update on public.jugadores
for each row execute function public.touch_updated_at();

-- Acceso: cualquiera con el link de la app puede ver y editar (app del equipo, sin login).
alter table public.jugadores enable row level security;
drop policy if exists "leer"   on public.jugadores;
drop policy if exists "crear"  on public.jugadores;
drop policy if exists "editar" on public.jugadores;
drop policy if exists "borrar" on public.jugadores;
create policy "leer"   on public.jugadores for select to anon using (true);
create policy "crear"  on public.jugadores for insert to anon with check (true);
create policy "editar" on public.jugadores for update to anon using (true) with check (true);
create policy "borrar" on public.jugadores for delete to anon using (true);

-- Cambios en vivo: cuando alguien carga algo, el resto lo ve sin recargar.
do $$ begin
  alter publication supabase_realtime add table public.jugadores;
exception when duplicate_object then null; end $$;

-- Plantel inicial
insert into public.jugadores (id, name, num, ideal, alt1, alt2) values
  ('p1','Agustín Campos',null,null,null,null),
  ('p2','Martín Prat',null,null,null,null),
  ('p3','Pablo González',null,null,null,null),
  ('p4','Ale Maya',null,null,null,null),
  ('p5','Pablo Grosso',null,null,null,null),
  ('p6','Ger Ríos',null,null,null,null),
  ('p7','Pablo Maya',null,null,null,null),
  ('p8','Ignacio Pastore',null,null,null,null),
  ('p9','Javi Vestillero',null,null,null,null),
  ('p10','Martín Amas',null,null,null,null),
  ('p11','Kevin Misciel',null,null,null,null),
  ('p12','Gastón Covetta',43,'DFD','DFI','MD'),
  ('p13','Emiliano Chaparro',null,null,null,null),
  ('p14','Fernando Areán',null,null,null,null),
  ('p15','Ger Mansilla',null,null,null,null)
on conflict (id) do nothing;

-- Apodo (agregado después)
alter table public.jugadores add column if not exists nick text;

-- Pierna hábil (D = derecha, I = izquierda, A = ambas)
alter table public.jugadores add column if not exists foot text;
