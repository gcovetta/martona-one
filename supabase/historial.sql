-- Historial de cambios de Martona United
-- Guarda una copia de cada ficha ANTES de que se edite o se borre.
-- Pegar completo en Supabase → SQL Editor (pestaña nueva) → Run.

create table if not exists public.jugadores_historial (
  hid         bigint generated always as identity primary key,
  jugador_id  text not null,
  accion      text not null,          -- 'editado' o 'borrado'
  antes       jsonb not null,         -- la ficha completa como estaba
  cuando      timestamptz not null default now()
);

-- Nadie lo ve ni lo toca desde la app: solo vos desde el panel de Supabase.
alter table public.jugadores_historial enable row level security;

create or replace function public.guardar_historial() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.jugadores_historial (jugador_id, accion, antes)
  values (old.id, case when tg_op = 'DELETE' then 'borrado' else 'editado' end, to_jsonb(old));
  return coalesce(new, old);
end $$;

drop trigger if exists jugadores_historial_trg on public.jugadores;
create trigger jugadores_historial_trg
after update or delete on public.jugadores
for each row execute function public.guardar_historial();

-- Ver los últimos cambios:
--   select hid, jugador_id, accion, antes->>'name' as nombre, cuando
--   from public.jugadores_historial order by cuando desc limit 30;
--
-- Recuperar una ficha tal como estaba en un cambio (reemplazá 123 por el hid):
--   insert into public.jugadores
--   select * from jsonb_populate_record(null::public.jugadores,
--          (select antes from public.jugadores_historial where hid = 123))
--   on conflict (id) do update set
--     name = excluded.name, nick = excluded.nick, num = excluded.num, ideal = excluded.ideal,
--     alt1 = excluded.alt1, alt2 = excluded.alt2, photo = excluded.photo, foot = excluded.foot,
--     inj = excluded.inj, inj_weeks = excluded.inj_weeks, inj_since = excluded.inj_since;
