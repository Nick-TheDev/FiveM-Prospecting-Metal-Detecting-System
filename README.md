# FiveM Prospecting/Metal Detecting System

A standalone FiveM script that adds a functional metal detector system with configurable search zones, rewards, and sales. Built using **Ox Lib** for notifications and optional Ox Inventory integration.

---

## 🇮🇹 Readme Italiano

### Panoramica

Questo script fornisce un **sistema standalone di metal detector/caccia al tesoro** per FiveM. I giocatori possono esplorare zone preimpostate per trovare ricompense usando un metal detector, con possibilità opzionale di interagire per vendere gli oggetti. Include:

* Zone di ricerca.
* Probabilità di ricompensa e spawn dinamico di props.
* Animazioni e sequenze di telecamera per scavare.
* Notifiche customizzabile, zone poly e altri menu gestiti tramite **Ox Lib**.
* Integrazione opzionale con Ox Inventory (attualmente commentata nel file _sv.lua) per la gestione degli oggetti.
* Sistema SNS per prevenire il recupero multiplo della stessa arma speciale (`GlobalState.SNStrovata = false`).
* Il metal detector ha un prop custom

### Funzionalità principali

* **Zone:** Definisci più zone di ricerca usando poligoni con `lib.zones.poly`.
* **Sistema di ricompense:** Ogni zona ha oggetti configurabili con probabilità definite.
* **Logica Arma SNS:** Gestione speciale per evitare che la `weapon_snspistol` venga generata se già trovata (`GlobalState.SNStrovata = true`).
* **Animazioni di scavo:** Animazioni e props personalizzati durante lo scavo.
* **Interazione vendita:** NPC per il banco dei pegni con supporto opzionale a ox_target.
* **Script standalone:** Nessuna dipendenza oltre a **Ox Lib**; può essere facilmente integrato con Ox Inventory o altri sistemi di inventario se necessario.

### Requisiti

* **Ox Lib (Obbligatorio):** Per notifiche e rilevamento zone.
* **Opzionale:** Integrazione con Ox Inventory presente ma commentata; attivabile se necessario.

### Installazione

1. Assicurati che **Ox Lib** sia installato nelle risorse del server.
2. Inserisci la cartella `fivem-metal-detector` nella directory `resources` del server.
3. Aggiungi `ensure fivem-metal-detector` al tuo `server.cfg`.
4. Configura il tutto tramite il file _cfg.lua.
5. Aggiungi all'item prediletto come metaldetector l'export "UsaMetalDetector".
6. Commenta il comando /metal nel file client se necessario.

### Utilizzo

| Comando                   | Descrizione                                                                                  |
| :------------------------ | :------------------------------------------------------------------------------------------- |
| `/metal`                  | Attiva/disattiva il metal detector quando il giocatore è all'interno di una zona di ricerca. |
| Export `UsaMetalDetector` | Permette l’attivazione programmata dello script da altri script.                             |

* Il metal detector funziona solo all’interno delle zone definite. Tentare di usarlo fuori mostra una notifica.
* Premi `E` per scavare quando viene segnato un punto di ricompensa.

### Configurazione

Configurabile in `_cfg.lua`:

* `ConfigMetalDetector.Locale` – Selezione lingua.
* `ConfigMetalDetector.Zone` – Definizione delle zone, punti poligonali, probabilità delle ricompense.
* `ConfigMetalDetector.VenditaItem` – Oggetti vendibili.
* `ConfigMetalDetector.Notify` – Funzione per le notifiche usando **Ox Lib**.
* `ConfigMetalDetector.ItemName` – Nome dell’oggetto metal detector.
* `ConfigMetalDetector.MoneyItemName` – Nome dell’oggetto usato come denaro.

```lua
-- Esempio di zona
ConfigMetalDetector.Zone["zona_1"] = {
    centro_blip = vector3(1527.67, 6622.92, 2.47),
    poly = lib.zones.poly({
        points = { vec3(...), vec3(...), ... },
        onEnter = function() attualezona = "zona_1" end,
        onExit = function() attualezona = nil end,
    }),
    ricompense = {
        [30] = { item = "gold", prop = "prop_bottle_cap_01" },
        [60] = { item = "accendino", prop = "v_res_tt_lighter" },
        [100] = { item = "weapon_bzgas", prop = "w_ex_grenadesmoke" }
    }
}
```

Ecco la **traduzione completa in inglese**, pulita e pronta da usare:

---

## 🇬🇧 English Readme

### Overview

This script provides a **standalone metal detector / treasure hunting system** for FiveM. Players can explore predefined zones to find rewards using a metal detector, with an optional interaction to sell found items. It includes:

* Search zones.
* Reward chances and dynamic prop spawning.
* Digging animations and camera sequences.
* Custom notifications, poly zones, and menus handled via **Ox Lib**.
* Optional Ox Inventory integration (currently commented out in `_sv.lua`) for item handling.
* SNS system to prevent multiple pickups of the same special weapon (`GlobalState.SNStrovata = false`).
* Custom prop for metal detector

### Main Features

* **Zones:** Define multiple search areas using polygon zones with `lib.zones.poly`.
* **Reward system:** Each zone has configurable items with defined probabilities.
* **SNS Weapon Logic:** Special handling to prevent `weapon_snspistol` from spawning if it has already been found (`GlobalState.SNStrovata = true`).
* **Digging animations:** Custom animations and props during the digging sequence.
* **Selling interaction:** Pawn shop NPC with optional ox_target support.
* **Standalone script:** No dependencies other than **Ox Lib**; can be easily integrated with Ox Inventory or other inventory systems if needed.

### Requirements

* **Ox Lib (Required):** Used for notifications and zone detection.
* **Optional:** Ox Inventory integration is present but commented out; can be enabled if needed.

### Installation

1. Make sure **Ox Lib** is installed in your server resources.
2. Place the `fivem-metal-detector` folder inside your server `resources` directory.
3. Add `ensure fivem-metal-detector` to your `server.cfg`.
4. Configure everything through the `_cfg.lua` file.
5. Add the export `"UsaMetalDetector"` to your preferred metal detector item.
6. Comment out the `/metal` command in the client file if needed.

### Usage

| Command                   | Description                                                                  |
| :------------------------ | :--------------------------------------------------------------------------- |
| `/metal`                  | Enables/disables the metal detector when the player is inside a search zone. |
| Export `UsaMetalDetector` | Allows programmatic activation of the script from other resources.           |

* The metal detector only works inside defined zones. Using it outside will show a notification.
* Press `E` to dig when a reward point is marked.

### Configuration

Configurable via `_cfg.lua`:

* `ConfigMetalDetector.Locale` – Language selection.
* `ConfigMetalDetector.Zone` – Zone definitions, polygon points, and reward probabilities.
* `ConfigMetalDetector.VenditaItem` – Sellable items.
* `ConfigMetalDetector.Notify` – Notification function using **Ox Lib**.
* `ConfigMetalDetector.ItemName` – Metal detector item name.
* `ConfigMetalDetector.MoneyItemName` – Item name used as currency.

```lua
-- Zone example
ConfigMetalDetector.Zone["zona_1"] = {
    centro_blip = vector3(1527.67, 6622.92, 2.47),
    poly = lib.zones.poly({
        points = { vec3(...), vec3(...), ... },
        onEnter = function() attualezona = "zona_1" end,
        onExit = function() attualezona = nil end,
    }), 
    ricompense = {
        [30] = { item = "gold", prop = "prop_bottle_cap_01" },
        [60] = { item = "lighter", prop = "v_res_tt_lighter" },
        [100] = { item = "weapon_bzgas", prop = "w_ex_grenadesmoke" }
    }
}
```

|                                         |                                |
|-------------------------------------|----------------------------|
| Code is accessible       | Yes                |
| Subscription-based      | No                 |
| Lines (approximately)  | 700 |
| Requirements                | OxLib|
| Support                           | Yes                 |