# Martona United · Más 40

App del plantel: cada jugador carga su posición ideal y dos alternativas, si está lesionado y cuántas semanas le faltan. La cancha muestra a todos en su posición ideal para ver dónde sobran o faltan jugadores, y la tabla lo resume por puesto.

## Puesta en marcha
1. **Supabase:** crear un proyecto, abrir *SQL Editor*, pegar `supabase/schema.sql` y ejecutar.
2. En *Project Settings → API* copiar la **Project URL** y la **publishable key** (o la anon key en Legacy API Keys), y pegarlas en `index.html` (`SUPABASE_URL` y `SUPABASE_ANON_KEY`).
3. **GitHub Pages:** *Settings → Pages → Deploy from a branch → main / root*. Queda en `https://gcovetta.github.io/martona-one/`.

Sin las claves de Supabase, la app funciona igual pero guarda solo en el navegador de cada uno.

**Ojo:** no hay login. Cualquiera que tenga el link puede ver y editar el plantel.

## App instalable y versiones
- Es una app web instalable (PWA): en iPhone, Safari → Compartir → *Agregar a inicio*; en Android, Chrome → *Instalar app*.
- **En cada publicación**, subí el número en `APP_VERSION` (index.html) y en `VERSION` (sw.js), los dos iguales. Así la app instalada muestra "Hay una versión nueva · Actualizar".
