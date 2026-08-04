# Valonde

Conversión total de mapa para Hearts of Iron IV 1.19.2.0 (Operation Postern). El repositorio contiene un prototipo técnico: geografía Mercator, provincias generadas, capas mínimas y un escenario provisional de un solo país (`VLD`).

## Regenerar el MVP

Desde la raíz del repositorio, con Python 3 y Pillow instalados:

```powershell
python tools\build_clean_heightmap.py
python tools\generate_world_normal.py
python tools\generate_land_mask.py
python tools\generate_provinces.py
python tools\generate_mvp_rasters.py
python tools\generate_mvp_colormaps.py
python tools\generate_mvp_scenario.py
python tools\validate_mvp.py
```

Los archivos bajo `source/` son fuentes y reportes; los archivos que consume HOI4 se exportan a sus rutas vanilla (`map/`, `history/`, `common/`, `localisation/` y `gfx/`). No se modifica la instalación de Steam.

## Retrato de Tarkan Rohendel

El maestro editable está en `source/portraits/tarkan_rohendel.png`. Regenerar los DDS grande y pequeño con:

```powershell
.\tools\export_hoi4_portrait.ps1 -InputPath source\portraits\tarkan_rohendel.png -LargePath gfx\leaders\SHA\portrait_SHA_tarkan_rohendel.dds -SmallPath gfx\interface\ideas\portrait_SHA_tarkan_rohendel_small.dds
```

## Estado

Las comprobaciones estáticas están automatizadas. Con solo `valonde` activo, HOI4 inicia con `-debug`, carga 2842 entradas de provincia (ID 0 más 2841 provincias), llega al frontend y permanece estable sin errores propios de definición, costura, tamaño provincial, puertos o texturas DDS.

El bookmark y la selección de `VLD` ya se comprobaron. Todavía hace falta confirmar la carga después de retirar las reglas de adyacencia vanilla, verificar visualmente que desapareció su colormap fantasma, quitar la pausa y avanzar un mes. Las etiquetas vanilla permanecen visibles porque gran parte del contenido base las referencia; sus historias siguen aisladas y pueden producir avisos no cartográficos.
