# Keymap — Corne TP

Layout diseñado para **macOS**, programación en **Kotlin/TypeScript/Angular** (IntelliJ + WebStorm), escritura frecuente en **español**, y uso del **trackpad integrado** en la mitad derecha.

Este keymap utiliza comportamientos avanzados de ZMK como **macros** y **hold-tap** para maximizar la eficiencia tanto en programación como en escritura en español.

## Requisito previo en macOS

Configurar el input source a **"ABC Extended"** en `System Settings → Keyboard → Input Sources`. **Este paso es crucial**; si se utiliza otra distribución (como "Spanish" o "U.S." estándar), los símbolos de programación (`{}[]|\`) y los acentos no funcionarán como se espera.

---

## Visualización completa

> Este SVG se genera automáticamente con [keymap-drawer](https://github.com/caksoylar/keymap-drawer) cada vez que cambia el keymap. No editar manualmente.

![Keymap](../assets/imgs/corne_tp.svg)

---

## Layer 0 — BASE

Letras QWERTY, puntuación básica, modificadores dedicados.

### Por qué cada tecla está donde está

- **LGUI (Cmd)** en pulgar izquierdo central → posición más cómoda para el modificador más usado en macOS (Cmd+C, Cmd+V, Cmd+S, Cmd+Z, Cmd+Tab…). Se combina fácilmente con cualquier letra de la mano izquierda.
- **LCTRL & LGUI** en el clúster del pulgar izquierdo → Acceso rápido a los modificadores más comunes.
    - **Acento (ACUT)** como tecla muerta en la fila de inicio derecha → Permite una escritura de tildes natural e intuitiva, similar a un teclado español estándar.
    - **Hold-Taps** para puntuación en la fila inferior derecha → `&ht SEMI COMMA` (tap para `;`, hold para `,`) y `&ht COLON DOT` (tap para `:`, hold para `.`) optimizan el acceso a símbolos comunes.
    - **Macros para español**: Teclas dedicadas para `ñ`, `¿` y `¡` simplifican la escritura.

---

## Layer 1 — SYM

Símbolos de programación. Se activa manteniendo **MO(1)** (pulgar izquierdo interno).

### Organización

- **Home row izquierda**: `( ) { }` — los pares más usados en Kotlin/TS (llamadas a funciones, bloques, lambdas, objetos).
- **Home row derecha**: `[ ] < >` — arrays, genéricos, tags Angular/HTML.
- **Pares adyacentes**: cada par de apertura/cierre está al lado del otro para facilitar la memoria muscular.
- **Fila superior**: símbolos de Shift+número (familiar del teclado US), más `-` y `+`.
- **Fila inferior**: `\ | / ? :` a la izquierda, `; " ¿ ¡` a la derecha.
- **`¿` y `¡`**: macros ZMK que envían Option+Shift+/ y Option+1 automáticamente.
- **`___`** = transparente → LSHIFT, LALT y RSHIFT de la capa base siguen accesibles.

### Acceso a SYS desde SYM

Manteniendo MO(1) + pulsando MO(3) (pulgar derecho interno) → activa la capa SYS.

---

## Layer 2 — NUMAV (Números + Navegación)

Se activa manteniendo **MO(2)** (pulgar derecho interno).

### Organización

**Mano izquierda — numpad:**
- **Fila 1**: 7 8 9 (cols 1-3) + HOME / END (cols 4-5)
- **Fila 2**: 4 5 6 (cols 1-3) + PG_UP / PG_DN (cols 4-5)
- **Fila 3**: 0 1 2 3 (cols 0-3) — el 0 ocupa la esquina del meñique

**Mano derecha — flechas T-invertida (estilo gamer):**
```
   ↑
← ↓ →
```
- ↑ en fila 1 col 1, alineado sobre ↓ en fila 2 col 1
- ← ↓ → en fila 2 cols 0-2

**Combinable con modificadores** (transparentes desde base):
- Cmd+← = inicio de línea
- Cmd+→ = fin de línea
- Option+← = saltar palabra
- Shift+↓ = seleccionar línea
- Cmd+Shift+→ = seleccionar hasta fin de línea

### Acceso a SYS desde NUMAV

Manteniendo MO(2) + pulsando MO(3) (pulgar izquierdo interno) → activa la capa SYS.

---

## Layer 3 — SYS (Bluetooth, multimedia, brillo)

Se accede desde SYM o NUMAV manteniendo **MO(3)**.

### Funciones

- **BT 0–4**: selección de perfil Bluetooth (hasta 5 dispositivos).
- **BT_CLR**: borrar emparejamiento del perfil activo.
- **OUT_TOG**: alternar salida USB/Bluetooth.
- **SOFT_OFF**: entrar en deep sleep (ahorro de batería).
- **Brillo**: BRI_DN / BRI_UP (control de brillo de pantalla en macOS).
- **Volumen**: VOL_DN / VOL_UP / MUTE.
- **Multimedia**: PREV / PLAY (play/pause) / NEXT.

---

## Escritura en Español

El teclado está optimizado para escribir en español de forma fluida y natural.

### Acentos con Tecla Muerta

Se utiliza una **tecla muerta (dead key)** para los acentos agudos mediante un macro que envía `Option+E`, imitando el comportamiento estándar de macOS.

1.  Pulsa la tecla de acento agudo (posición 35, meñique derecho en la home row de la capa base) — macro `&acut` que envía `Option+E`.
2.  A continuación, pulsa la vocal que deseas acentuar (a, e, i, o, u).

El resultado será la vocal acentuada (á, é, í, ó, ú).

### Caracteres y Símbolos Españoles

| Carácter | Cómo teclearlo |
|----------|---------------|
| ñ | Tecla dedicada en la capa **BASE** (posición 34, anular derecho). |
| ¿ | Tecla dedicada en la capa **SYM** (macro `&inv_qmark`). |
| ¡ | Tecla dedicada en la capa **SYM** (macro `&inv_excl`). |
| € | Tecla dedicada en la capa **SYM** (macro `&euro`). |

---

## Cómo acceder a la capa SYS

La capa SYS no se accede directamente desde BASE. Hay dos caminos:

1. **Desde SYM**: mantén MO(1) (pulgar izq interno) → pulsa MO(3) (pulgar der interno).
2. **Desde NUMAV**: mantén MO(2) (pulgar der interno) → pulsa MO(3) (pulgar izq interno).

En ambos casos se necesitan dos pulgares: uno mantiene la capa intermedia y el otro activa SYS. Al soltar cualquiera, vuelves a la capa anterior o a BASE.

---

## Resumen de pulgares (Capa Base)

```
Pulgar izq externo (36):  LCTRL     — Control
Pulgar izq central (37):  LGUI      — Cmd (macOS)
Pulgar izq interno (38):  MO(NUMAV) — activa la capa NUMAV mientras se mantiene
Pulgar der interno (39):  MO(SYM)   — activa la capa SYM mientras se mantiene
Pulgar der central (40):  SPACE     — Espacio
Pulgar der externo (41):  ENTER     — Enter/Return
```