# AGENTS.md — Valonde

## Propósito del proyecto

Valonde es un mod de reemplazo total del mapa. El objetivo confirmado por el propietario es crear un mapa completamente nuevo para **Hearts of Iron IV**, no limitarse a retocar provincias del mapa original.

Un reemplazo total del mapa incluye, como mínimo:

- geografía terrestre y marítima;
- provincias, IDs y relaciones de vecindad;
- terreno, clima y continentes o regiones equivalentes;
- ríos, costas, estrechos y conexiones especiales;
- posiciones de ciudades, puertos, unidades y demás objetos del mapa;
- países, estados o regiones necesarios para que el escenario cargue;
- localización, historia y recursos mínimos asociados al nuevo mundo;
- recursos gráficos exigidos por el motor;
- validación técnica hasta llegar al menú, cargar una partida y avanzar tiempo sin errores críticos.

## Entorno confirmado

La instalación local del juego base está en:

```text
E:\SteamLibrary\steamapps\common\Hearts of Iron IV
```

Los logs de ejecución que deben revisarse después de cada prueba están en:

```text
C:\Users\sakya\OneDrive\Documentos\Paradox Interactive\Hearts of Iron IV\logs
```

Empezar por `error.log`, correlacionándolo con `system.log`, `setup.log` y `game.log` de la misma ejecución.

Usar esa instalación como referencia vanilla de solo lectura. En particular, el mapa base de referencia está en:

```text
E:\SteamLibrary\steamapps\common\Hearts of Iron IV\map
```

Reglas obligatorias:

- nunca editar, renombrar ni borrar archivos bajo la instalación de Steam;
- comparar con vanilla antes de cambiar formatos o estructura;
- copiar al mod solo los archivos que se vayan a reemplazar o que sean necesarios para mantener coherencia;
- si Steam actualiza el juego, no sincronizar a ciegas: comparar primero y registrar la migración;
- no usar archivos ni convenciones de Hearts of Iron II, Darkest Hour u otros títulos de Paradox.

## Perfil técnico confirmado

Mantener esta ficha actualizada; es la fuente de verdad del proyecto.

| Campo | Valor actual |
|---|---|
| Nombre | Valonde |
| Tipo | Reemplazo total del mapa / total conversion |
| Juego objetivo | Hearts of Iron IV para Steam |
| Ruta vanilla | `E:\SteamLibrary\steamapps\common\Hearts of Iron IV` |
| Versión declarada por el descriptor | `1.19.2.0` |
| Versión instalada comprobada | Operation Postern 1.19.2.0.a729 (`d245`) |
| Sistema principal | Windows |
| Idioma de documentación | Español |
| Idioma de claves y nombres técnicos | Inglés, ASCII y `snake_case` salvo requisito del motor |
| Estado | Prototipo MVP llega al frontend; pendiente cargar `VLD` y avanzar un mes |

## Línea base y estado actual de `map/`

El commit `99be615a` congeló la copia vanilla que sirve de referencia. Desde entonces el pipeline sustituyó las capas incompatibles y retiró del mod los estados, unidades, regiones estratégicas y áreas de suministro vanilla. Esas eliminaciones son recuperables mediante Git; la instalación de Steam no se modificó.

Estado estático del prototipo:

- mapa de 5632×2048 con heightmap y máscara tierra/mar propios;
- 2841 provincias: 1883 terrestres y 958 marítimas;
- una tabla maestra en `source/data/provinces.csv`;
- una región estratégica, un área de suministro, un estado y un país provisional (`VLD`);
- terreno, ciudades, árboles y ríos provisionales sin geografía vanilla;
- pruebas reproducibles aprobadas mediante `python tools\validate_mvp.py`.

Desde este punto:

- revisar `git diff` antes y después de cada cambio;
- no volver a copiar toda la carpeta vanilla sobre `map/`, porque borraría trabajo nuevo;
- modificar una capa del mapa a la vez y validar sus referencias cruzadas;
- si un archivo sigue siendo idéntico a vanilla y HOI4 no necesita que el mod lo incluya, se puede evaluar retirarlo en una tarea separada, nunca como limpieza incidental.

## Jerarquía de fuentes

Cuando haya dudas técnicas, usar este orden:

1. archivos vanilla de la **misma edición y versión instalada**;
2. documentación oficial y herramientas incluidas con el juego;
3. documentación mantenida por la comunidad para esa versión exacta;
4. mods conocidos que carguen en esa misma versión, solo como referencia secundaria.

No inventar formatos ni trasladar convenciones entre juegos de Paradox. Antes de crear un tipo de archivo nuevo, encontrar su equivalente vanilla y conservar su codificación, delimitadores, dimensiones, paleta y estructura.

Los archivos vanilla son referencia de formato, no material para sobrescribir. Todo cambio debe quedar dentro del mod.

## Alcance funcional

El trabajo se divide en capas dependientes. Completar y validar una capa antes de ampliar la siguiente:

1. **Arranque del mod**: descriptor correcto, ruta correcta y carga del mod sin contenido de mapa.
2. **Mapa mínimo**: imágenes y tablas mínimas coherentes, IDs válidos y escenario capaz de llegar al menú.
3. **Topología**: provincias terrestres y marítimas, costas, lagos, ríos, adyacencias, estrechos y conexiones.
4. **Semántica**: terreno, regiones, continentes, clima y posiciones.
5. **Mundo jugable**: países, propiedad/control, capitales, recursos, infraestructuras y unidades mínimas.
6. **Presentación**: nombres, localización, colores, iconos y acabado visual.
7. **Contenido ampliado**: historia, eventos, IA, balance, música y narrativa.

La prioridad inicial es un mapa técnicamente válido y pequeño. No comenzar árboles, eventos extensos, balance o arte final mientras el mapa base aún no carga de forma estable.

### Provincias y escenario MVP

- `source/map/land_mask.png` se deriva del heightmap limpio con `tools/generate_land_mask.py`.
- `tools/generate_provinces.py` deriva `source/data/provinces.csv`, `map/provinces.bmp` y `map/definition.csv` de la misma topología.
- Los IDs son contiguos: 1–1883 tierra y 1884–2841 mar. Los colores se calculan con `(id * 0x9E3779) & 0xFFFFFF`; el negro queda reservado.
- La densidad provisional usa espaciado de 64 píxeles en tierra y 128 en mar; ninguna provincia tiene menos de 16 píxeles.
- `tools/generate_mvp_rasters.py` genera capas visuales técnicas de terreno, ciudades, ríos y árboles.
- `tools/generate_mvp_colormaps.py` deriva los DDS terrestres, acuáticos y de niebla del heightmap; no conservar colormaps vanilla porque superponen su geografía como una marca de agua.
- `tools/generate_mvp_scenario.py` genera el escenario de prueba completo con un estado, `VLD`, su bookmark, localización, banderas provisionales y posiciones de puerto Nudge 19/20 para cada provincia costera.
- `map/adjacency_rules.txt` debe permanecer vacío mientras `adjacencies.csv` no defina conexiones especiales. Las reglas vanilla referencian provincias inexistentes y activan el aviso de definición del mapa.
- Las rutas vanilla incompatibles se aíslan con `replace_path` en ambos descriptores-


## Estructura prevista del repositorio

Conservar las rutas que Hearts of Iron IV espera y separar las fuentes de trabajo de los archivos que consume el juego:

```text
valonde/
├── AGENTS.md
├── README.md                 # instalación, versión y estado para personas
├── CHANGELOG.md              # cambios visibles y migraciones de IDs
├── descriptor.mod            # metadatos del mod para HOI4
├── map/                      # archivos de mapa que consume HOI4
├── history/                  # estados, países y unidades iniciales
├── localisation/             # nombres visibles
├── gfx/                      # recursos gráficos exportados
├── tools/                    # scripts reproducibles de generación/validación
```

El layout vanilla de HOI4 prevalece. No añadir directorios “por limpieza” dentro de rutas que el motor analiza de forma especial.

## Convenciones de datos y archivos

- Los archivos de texto nuevos del repositorio usan LF, impuesto por `.gitattributes` y `.vscode/settings.json`. Conservar el BOM y la codificación que HOI4 requiera para cada tipo; no convertir archivos vanilla en masa sin una prueba real.
- Usar claves técnicas estables, descriptivas, en ASCII y sin espacios.
- Separar el nombre visible localizado de la clave técnica.
- Mantener números decimales con punto cuando el formato lo exija.
- No reordenar ni reformatear archivos grandes sin necesidad: dificulta revisar cambios y puede alterar parsers antiguos.
- No editar binarios o imágenes con herramientas que cambien metadatos críticos de manera silenciosa.
- No incluir cachés, miniaturas, copias de seguridad del editor, logs ni artefactos temporales.
- Las rutas y el uso de mayúsculas/minúsculas deben coincidir exactamente con vanilla, aunque Windows tolere diferencias.

## Automatización

Toda operación repetitiva o propensa a errores debe convertirse en una herramienta reproducible dentro de `tools/`, especialmente:

- asignación y auditoría de colores/IDs;
- detección de colores desconocidos o duplicados;
- comprobación de referencias huérfanas;
- validación de dimensiones, modo de color, paleta y formato;
- comprobación de posiciones fuera de provincia;
- generación de tablas derivadas;
- resumen del log de errores del juego.

Los scripts deben:

- ser deterministas;
- operar por defecto sobre copias o fuentes editables, no sobre la instalación vanilla;
- mostrar con claridad los archivos que modificarán;
- fallar con un mensaje útil y código distinto de cero;
- ofrecer `--check` o modo de solo lectura cuando sea razonable;
- documentar dependencias y comando de uso en `README.md` o en `tools/README.md`.

No introducir una dependencia pesada para una validación que pueda resolverse con la biblioteca estándar o con una herramienta ya adoptada por el proyecto.

## Flujo de trabajo obligatorio

Antes de cambiar archivos:

1. leer este documento y el `README.md`, si existe;
2. inspeccionar el estado real del repositorio;
3. identificar el archivo vanilla equivalente y la versión exacta;
4. declarar cualquier supuesto que pueda afectar IDs, dimensiones o compatibilidad;
5. hacer el cambio mínimo que permita validar una hipótesis.

Después de cambiar archivos:

1. ejecutar validadores estáticos disponibles;
2. comprobar que no se modificaron archivos ajenos al alcance;
3. iniciar el juego con logs detallados cuando sea posible;
4. probar menú, carga del escenario y avance de tiempo;
5. revisar el log desde el primer error relevante, no solo el último;
6. documentar cambios de esquema, IDs o requisitos de instalación.

No afirmar que un mapa “funciona” basándose solo en que las imágenes se abren o que el juego llega al menú.

## Estrategia de pruebas

Aplicar pruebas en este orden para localizar fallos con rapidez:

1. **Validación de archivos**: existencia, nombres, codificación, dimensiones y formato.
2. **Integridad referencial**: IDs duplicados, faltantes, fuera de rango y referencias inexistentes.
3. **Integridad gráfica**: colores válidos, píxeles desconocidos, costas, ríos y paleta.
4. **Carga del motor**: arranque limpio y carga de escenario sin bloqueo.
5. **Prueba de humo jugable**: seleccionar país, iniciar partida, quitar pausa y avanzar al menos un mes de juego.
6. **Casos de borde**: unidades navales, puertos, islas, estrechos, cambio de propietario y pathfinding.

Si el juego falla:

- conservar el primer error reproducible y el fragmento de log pertinente;
- reducir el caso antes de hacer varios cambios a la vez;
- no ocultar errores eliminando contenido obligatorio;
- registrar la causa y la corrección en `docs/troubleshooting.md` cuando pueda repetirse.

## Seguridad y preservación

- Nunca sobrescribir ni borrar archivos del juego base.
- Nunca ejecutar limpiezas recursivas sobre la carpeta de usuario o instalación.
- Hacer copia recuperable antes de reemplazar una imagen binaria que no esté bajo control de versiones.
- Tratar cambios masivos de IDs, colores y nombres de archivo como migraciones: preparar mapa de equivalencias y validar todas las referencias.
- Preservar cambios existentes del propietario; no revertir ni “normalizar” trabajo que no pertenece a la tarea actual.
- No copiar recursos de terceros sin licencia o permiso compatible. Registrar autoría y licencia en `CREDITS.md`.

## Control de versiones

Este directorio es un repositorio Git. La política local y versionada usa LF y desactiva la firma GPG de commits y tags. No cambiar estas opciones sin petición del propietario. Mantener además un `.gitignore` específico para herramientas gráficas, logs y cachés cuando aparezcan esos artefactos.

Cada cambio debe ser pequeño y describir una sola intención. En particular, separar:

- cambios de IDs o esquema;
- cambios de geometría del mapa;
- regeneración de derivados;
- cambios de contenido o localización;
- cambios puramente visuales.

No almacenar archivos fuente gigantes y exportaciones redundantes sin decidir primero una estrategia de almacenamiento, por ejemplo Git LFS para binarios grandes.

## Registro de decisiones

Crear `docs/decisions/` cuando se tome la primera decisión técnica importante. Registrar al menos:

- juego, edición y versión objetivo;
- dimensiones y proyección del mapa;
- rango y política de asignación de IDs;
- formato de la tabla maestra de provincias;
- herramientas gráficas y exportadores aceptados;
- política de compatibilidad de partidas guardadas;
- procedencia y licencia de datos geográficos o recursos externos.

Una decisión aprobada prevalece sobre preferencias personales. Si debe cambiarse, añadir una nueva nota que explique la migración y los archivos afectados.

## Criterios de aceptación por tarea

Una tarea se considera terminada solo cuando:

- satisface el objetivo descrito sin ampliar el alcance;
- respeta el formato de la versión confirmada;
- no deja referencias rotas ni nuevos errores relevantes en el log;
- incluye o actualiza validación automatizada cuando corresponde;
- conserva fuentes editables y explica cómo regenerar derivados;
- actualiza documentación si cambia instalación, IDs, esquema o pipeline;
- informa qué se probó realmente y qué queda sin probar.

## Definición de “mapa base jugable”

El primer gran hito se alcanza cuando, en una instalación limpia de la versión objetivo:

- el launcher o selector reconoce el mod;
- el juego inicia con el mod activado;
- el mapa completo se renderiza sin áreas corruptas;
- el escenario carga sin bloqueo;
- existe al menos un país seleccionable con capital y territorio válidos;
- las rutas terrestres y navales básicas funcionan;
- se puede avanzar un mes sin cierre inesperado ni error crítico repetitivo;
- el procedimiento de instalación y reproducción está documentado.

## Instrucciones para agentes futuros

- Responder y documentar en español, salvo que el propietario pida otro idioma.
- Ser explícito al distinguir hechos observados, inferencias y decisiones pendientes.
- No inventar contenido geográfico o narrativo cuando la tarea sea puramente técnica.
- Trabajar exclusivamente con formatos y estructura de Hearts of Iron IV.
- No prometer compatibilidad con una versión que no haya sido probada.
- Ante una duda reversible y de bajo riesgo, elegir la opción mínima y documentarla.
- Ante una duda que cambie de motor, dimensiones, IDs globales, proyección o licencia, detenerse y pedir confirmación.
- Entregar siempre un resumen de archivos modificados, validaciones ejecutadas y riesgos pendientes.

## Próximo hito

El arranque aislado con `-debug` y solo `valonde` activo llega al frontend; el bookmark y `VLD` son seleccionables. Después de retirar `adjacency_rules.txt` vanilla, el log queda sin entradas `map.cpp`. Falta repetir la carga interactiva, confirmar que los nuevos DDS eliminaron la geografía fantasma, quitar la pausa y avanzar un mes. No considerar el MVP jugable hasta completar esa prueba.
