# AGENTS.md — Valonde

## Identidad del proyecto

Valonde es una conversión total de fantasía para **Hearts of Iron IV**. El mapa propio ya es la base del proyecto; la fase activa consiste en convertir sistemas, países, política, tecnología, unidades, arte y textos para que el juego represente un mundo fantástico coherente.

La ambientación toma como referencias de tono a Dungeons & Dragons, Dragon Age, The Elder Scrolls y The Witcher, pero debe tener nombres, personajes, facciones, textos, símbolos y arte originales. No copiar material protegido de esas obras.

Principios de diseño:

- fantasía política y militar antes que terminología del siglo XX;
- mecánicas de HOI4 reutilizadas cuando expresen bien la ficción;
- cambios mecánicos propios solo cuando una adaptación de datos o localización no sea suficiente;
- una facción jugable completa como vertical slice antes de transformar todo el mundo;
- lore y mecánicas deben coincidir: una afirmación importante debe verse en juego, aunque inicialmente sea mediante una solución mínima.

## Estado real del repositorio

El repositorio ya contiene el mapa y una base amplia de países, estados, personajes, ideas, unidades y localización. Parte de esa base conserva nombres, tecnologías, gobiernos, historias y otros datos vanilla usados durante la construcción inicial. Esos restos son deuda de conversión, no canon de Valonde.

La fase de prototipo técnico del mapa terminó. No regenerar ni sustituir capas del mapa salvo que una tarea trate expresamente un defecto cartográfico. La prioridad actual es una vertical slice de contenido fantástico, empezando por un imperio élfico.

## Perfil técnico

| Campo | Valor actual |
|---|---|
| Nombre | Valonde |
| Tipo | Conversión total de fantasía |
| Juego objetivo | Hearts of Iron IV para Steam |
| Versión del mod | `v0.1a` |
| Compatibilidad declarada | `1.19.*` |
| Sistema principal | Windows |
| Idioma de documentación | Español |
| Claves técnicas | Inglés, ASCII y `snake_case`, salvo requisito del motor |
| Fase actual | Conversión de contenido; vertical slice del imperio élfico |

Instalaciones vanilla conocidas, siempre de solo lectura:

```text
D:\SteamLibrary\steamapps\common\Hearts of Iron IV
C:\Program Files (x86)\Steam\steamapps\common\Hearts of Iron IV
```

Antes de usar una como referencia, comprobar su versión y elegir la que coincida con `supported_version`. Nunca editar, renombrar ni borrar archivos bajo Steam.

Logs de ejecución conocidos:

```text
C:\Users\sakya\OneDrive\Documentos\Paradox Interactive\Hearts of Iron IV\logs
C:\Users\sakya\Documents\Paradox Interactive\Hearts of Iron IV\logs
```

Revisar primero `error.log` y correlacionarlo con `system.log`, `setup.log` y `game.log` de la misma ejecución.

## Jerarquía de fuentes técnicas

Cuando haya dudas de formato o comportamiento:

1. archivos vanilla de la misma versión instalada;
2. documentación y herramientas de HOI4;
3. documentación comunitaria mantenida para esa versión;
4. mods que carguen en esa versión, solo como referencia secundaria.

No inventar formatos ni trasladar convenciones de otros juegos de Paradox. Comparar primero el archivo equivalente vanilla y conservar estructura, codificación y delimitadores. Copiar al mod solo lo necesario; nunca sincronizar carpetas vanilla completas.

## Dirección de diseño: imperio élfico

Canon confirmado:

- el imperio élfico corresponde al país `SHA`, definido en `history/countries/SHA - Shaq.txt`;
- existe un imperio élfico gobernado por el mismo emperador desde hace **3717 años**;
- solo los elfos pueden ocupar cargos políticos o participar en las decisiones del Estado;
- humanos y beastfolk viven dentro de sus fronteras, pero quedan excluidos del poder;
- una población híbrida humano-demoníaca forma una casta servil hereditaria sin derechos;
- legalmente, los integrantes de esa casta son propiedad del Estado y este cede su uso a individuos, en un sistema comparable al de los ilotas de Esparta;
- “tiefling” describe únicamente la referencia visual y no será el nombre final de la especie en Valonde.

Clasificación política de trabajo:

- **forma de gobierno:** autocracia imperial élfica;
- **doctrina gobernante:** supremacía élfica;
- **orden social:** castas raciales hereditarias;
- **sistema laboral:** servidumbre estatal, equivalente en la práctica a esclavitud;
- **acceso al poder:** monopolio élfico bajo el emperador y su corte.

Decisión técnica inicial: crear la subideología `elven_imperialism` dentro de `neutrality`. Vanilla ofrece `despotism`, que es la base mecánica más cercana, pero no expresa la supremacía élfica ni el sistema de castas. También existe `emperor_fascism` dentro de `fascism`, pero usarla asociaría el imperio con el fascismo moderno y no con su autocracia milenaria. No usar `nazism`.

No crear todavía una quinta ideología global. Eso obligaría a adaptar UI, diplomacia, IA, popularidades y contenido de todos los países. Reevaluarlo cuando estén definidas las grandes familias políticas de Valonde y exista una diferencia mecánica que no pueda expresarse mediante subideologías.

Los 3717 años deben representarse inicialmente en localización y, si tiene efecto jugable, mediante un rasgo o espíritu nacional. No usar una fecha de nacimiento negativa o fuera del rango del motor sin una prueba aislada que confirme que HOI4 la acepta.

### Checklist de la vertical slice

#### 1. Contrato mínimo de lore

- [x] Elegir el país y su tag: `SHA` (`history/countries/SHA - Shaq.txt`).
- [ ] Definir el nombre original del imperio, gentilicio y adjetivo.
- [ ] Definir nombre, título y pronombres del emperador.
- [ ] Fijar el calendario: fecha inicial del escenario y qué significa exactamente “3717 años”.
- [ ] Decidir por qué ha gobernado tanto tiempo: longevidad élfica, inmortalidad, magia, sucesión ritual u otra causa original.
- [ ] Definir tres rasgos políticos del régimen y una debilidad; estos guiarán sus modificadores.
- [ ] Decidir si existen elecciones, regencia, consejo, nobleza, sucesión o disputas internas.
- [ ] Dar un nombre original a la especie híbrida humano-demoníaca y evitar `tiefling` como clave o nombre visible.
- [ ] Definir el estatus jurídico y las condiciones de vida de humanos y beastfolk fuera del gobierno.
- [ ] Definir cómo el Estado registra, asigna, recupera y castiga a la casta servil.

#### 2. Gobierno mínimo funcional

- [x] Comparar `common/ideologies/00_ideologies.txt` vanilla con la versión instalada.
- [x] Añadir `elven_imperialism` bajo `neutrality`, tomando `despotism` como base mecánica y conservando los tipos de gobierno que el resto del mod todavía necesite.
- [ ] Añadir `replace_path="common/ideologies"` solo si el mod pasa a poseer una definición completa y validada de todas las ideologías necesarias.
- [x] Localizar el nombre y la descripción de la subideología en español e inglés.
- [ ] Localizar el nombre largo, nombre corto y adjetivo del país bajo ese gobierno.
- [ ] Definir el partido o institución gobernante y sus nombres localizado largo y corto.
- [ ] Crear o adaptar al emperador en `common/characters/`, con la subideología correcta.
- [ ] Asignar el emperador y el grupo gobernante en `history/countries/`.
- [ ] Desactivar elecciones o rotación de líder si contradicen el canon.
- [ ] Representar los 3717 años mediante descripción, rasgo o espíritu nacional; añadir efectos solo si expresan los rasgos políticos acordados.
- [ ] Representar el monopolio político élfico y la casta servil mediante ideas o modificadores nacionales, sin simular especies con sistemas que HOI4 no modele realmente.
- [ ] Añadir retrato, bandera o iconos propios cuando la lógica ya cargue sin errores.

#### 3. Coherencia jugable del imperio

- [ ] Sustituir nombres vanilla visibles en el país: partidos, líderes, ideas, estados, ciudades y unidades iniciales.
- [ ] Dar al imperio una situación inicial, objetivos y relaciones diplomáticas compatibles con su historia.
- [ ] Revisar focos, decisiones, eventos y IA que comprueben las cuatro ideologías vanilla y adaptar solo los que afecten a esta vertical slice.
- [ ] Revisar ideas, leyes y rasgos que presupongan democracia moderna, fascismo, comunismo o política del siglo XX.
- [ ] Comprobar que golpes, cambios de gobierno, exilio y guerras civiles no produzcan líderes o nombres vanilla.
- [ ] Crear una descripción de bookmark que explique el imperio, el emperador y el conflicto inicial.

#### 4. Validación

- [ ] Buscar referencias huérfanas a la nueva clave de subideología y a las claves de localización.
- [ ] Iniciar el juego con `-debug` y confirmar que no aparecen errores nuevos de ideologías, personajes o localización.
- [ ] Verificar en selección de país y pantalla política el nombre del gobierno, el emperador, el partido y el retrato.
- [ ] Cargar una partida, quitar la pausa y avanzar al menos un mes.
- [ ] Probar una acción diplomática y cualquier cambio de popularidad o gobierno disponible.
- [ ] Revisar los logs desde el primer error relevante y registrar los problemas repetibles.

### Criterio de terminado

La vertical slice está terminada cuando el imperio es seleccionable, muestra su gobierno y emperador correctos, conserva al gobernante durante la prueba, no expone texto político vanilla en sus pantallas principales y avanza un mes sin errores críticos nuevos.

## Roadmap de conversión fantástica

Después de aprobar la vertical slice, convertir por capas y no por carpetas completas:

1. **Política:** gobiernos, ideologías, leyes, diplomacia, facciones y autonomía.
2. **Tecnología:** definir primero la taxonomía fantástica; luego nombres, descripciones, iconos, costes y efectos.
3. **Fuerzas armadas:** unidades, equipo, doctrinas, comandantes y vocabulario militar.
4. **Economía:** recursos, industria, comercio, construcción y logística.
5. **Países:** historia, líderes, ideas, focos, decisiones, eventos e IA.
6. **Presentación:** localización completa, retratos, banderas, iconos, música y ambientación.
7. **Depuración global:** retirar contenido vanilla ya reemplazado y auditar cada `replace_path`.

Para tecnologías, empezar con una decisión explícita entre:

- conservar las mecánicas y cambiar tema, nombres e iconos; o
- cambiar también categorías, árbol y balance.

Usar la primera opción como predeterminada hasta que una mecánica fantástica concreta justifique la segunda.

## Flujo de trabajo obligatorio

Antes de cambiar contenido:

1. leer este documento y `README.md`;
2. revisar `git status` y el contenido ya existente del sistema y país afectados;
3. identificar el equivalente vanilla de la versión objetivo;
4. declarar decisiones de canon o compatibilidad que falten;
5. hacer el cambio mínimo que produzca una vertical slice comprobable.

Después de cambiar contenido:

1. ejecutar validadores estáticos disponibles;
2. revisar el diff y confirmar que no contiene regeneraciones o formato ajenos;
3. probar carga con `-debug` cuando el cambio afecte datos consumidos por el motor;
4. revisar los logs de esa ejecución;
5. documentar claves, compatibilidad o decisiones de diseño nuevas.

No afirmar que una función “sirve” solo porque el parser acepta sus archivos. Distinguir siempre entre validación estática, carga del juego y prueba jugable.

## Convenciones

- Mantener LF en archivos nuevos; conservar BOM o codificación cuando HOI4 lo exija.
- Usar claves estables y descriptivas en inglés, ASCII y `snake_case`.
- Separar claves técnicas de nombres visibles localizados.
- No reordenar ni reformatear archivos grandes sin necesidad.
- No incluir cachés, miniaturas, logs, copias de seguridad ni artefactos temporales.
- Respetar exactamente mayúsculas, minúsculas y rutas vanilla.
- Automatizar operaciones repetitivas o propensas a errores, no tareas únicas triviales.
- No añadir dependencias pesadas si la biblioteca estándar o una herramienta existente basta.

## Seguridad y control de versiones

- Nunca modificar la instalación del juego base.
- Nunca ejecutar limpiezas recursivas sobre Steam, la carpeta de usuario o la raíz del repositorio.
- Preservar cambios del propietario y no normalizar contenido ajeno a la tarea.
- Tratar cambios masivos de tags, IDs, claves o nombres como migraciones con mapa de equivalencias.
- No copiar recursos de terceros sin licencia compatible; registrar autoría en `CREDITS.md`.
- Mantener cada commit limitado a una intención: mecánica, contenido, localización, arte o derivados.
- Revisar `replace_path` como una decisión de propiedad completa sobre una ruta, no como una forma de ocultar errores.

## Instrucciones para agentes futuros

- Responder y documentar en español, salvo petición contraria.
- Distinguir hechos observados, inferencias y decisiones pendientes.
- No inventar canon importante cuando falte una decisión del propietario; sí usar mínimos técnicos reversibles.
- Trabajar exclusivamente con formatos de Hearts of Iron IV.
- No prometer compatibilidad con una versión no probada.
- Entregar siempre archivos modificados, validaciones ejecutadas y riesgos pendientes.

## Próximo hito

Completar el contrato mínimo de lore del imperio élfico y, con esas claves decididas, implementar su gobierno como primera vertical slice fantástica.
