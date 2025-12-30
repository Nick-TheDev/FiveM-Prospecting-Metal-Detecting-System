ConfigMetalDetector = {}

ConfigMetalDetector.Locale = "it"

ConfigMetalDetector.Languages = {
    ['it'] = {
        -- General
        title = "Metal Detector",
        search_zone = "Zona di ricerca",
        notify_enter = "Sei entrato in una zona di ricerca, utilizza il tuo metal detector!",
        notify_exit = "Sei uscito dalla zona di ricerca",
        only_in_zone = "Puoi utilizzare il metal detector solo nelle zone di ricerca",
        
        -- Gameplay
        dont_run = "Il metal detector non funzionerà correttamente se corri!",
        item_found = "[E] Hai trovato qualcosa, scava!",
        
        -- Sales Menu
        pawnshop_title = "Pawnshop",
        sell_item = "Vendi questo item",
        open_catalog = "Apri Catalogo Vendita",
        sell_success = "Hai venduto un %s per $%s",
        no_item = "Non hai l'item necessario!",
        
        -- Blips & Targets
        blip_name = "Zona di ricerca",
        target_label = "Parla con il ricettatore"
    },
    ['en'] = {
        -- General
        title = "Metal Detector",
        search_zone = "Search Zone",
        notify_enter = "You have entered a search zone, use your metal detector!",
        notify_exit = "You have left the search zone",
        only_in_zone = "You can only use the metal detector in search zones",
        
        -- Gameplay
        dont_run = "The metal detector won't work properly if you run!",
        item_found = "[E] You found something, dig it up!",
        
        -- Sales Menu
        pawnshop_title = "Pawnshop",
        sell_item = "Sell this item",
        open_catalog = "Open Sales Catalog",
        sell_success = "You sold a %s for $%s",
        no_item = "You don't have the required item!",
        
        -- Blips & Targets
        blip_name = "Search Zone",
        target_label = "Talk to the fence"
    }
}


ConfigMetalDetector.Notify = function (title, description, duration, position)
    lib.notify({
        title = title,
        description = description,
        duration = duration,
        position = position -- top | top-left | top-right | bottom | bottom-left | bottom-right
    })
end 

ConfigMetalDetector.ItemName = "metaldetector"-- metaldetector item name
ConfigMetalDetector.MoneyItemName = "money"-- item use for money
ConfigMetalDetector.UseTarget = false -- true to use ox_target for pawnshop interaction, false to use a simple proximity check

ConfigMetalDetector.Zone = {
    ["zona_1"] = {
        centro_blip = vector3(1527.67, 6622.92, 2.47),
        poly = lib.zones.poly({
            points = { 
                vec3(1576.867310, 6653.913086, 1.715157),
                vec3(1573.088867, 6642.003418, 1.715157),
                vec3(1568.348511, 6633.564941, 1.715157),
                vec3(1560.702881, 6627.482422, 1.715157),
                vec3(1556.139893, 6620.748535, 1.715157),
                vec3(1553.744629, 6614.072266, 1.715157),
                vec3(1550.005981, 6603.659180, 1.715157),
                vec3(1542.163452, 6600.538086, 1.715157),
                vec3(1534.031372, 6595.257324, 1.715157),
                vec3(1525.332520, 6595.771973, 1.715157),
                vec3(1516.225586, 6595.802246, 1.715157),
                vec3(1509.913086, 6592.943359, 1.715157),
                vec3(1506.263550, 6588.235840, 1.715157),
                vec3(1501.680054, 6591.066406, 1.715157),
                vec3(1498.319580, 6593.951660, 1.715157),
                vec3(1494.856323, 6597.524414, 1.715157),
                vec3(1494.481812, 6604.192871, 1.715157),
                vec3(1494.570679, 6610.901855, 1.715157),
                vec3(1494.289551, 6613.431641, 1.715157),
                vec3(1490.753174, 6614.236816, 1.715157),
                vec3(1487.738403, 6617.260254, 1.715157),
                vec3(1483.280518, 6617.666992, 1.715157),
                vec3(1481.558350, 6621.358398, 1.715157),
                vec3(1474.052368, 6622.092285, 1.715157),
                vec3(1478.358032, 6629.753418, 1.715157),
                vec3(1480.861694, 6634.459961, 1.715157),
                vec3(1490.321655, 6638.287109, 1.715157),
                vec3(1497.434204, 6638.339844, 1.715157),
                vec3(1506.816040, 6639.086426, 1.715157),
                vec3(1517.004883, 6638.897949, 1.715157),
                vec3(1516.848511, 6634.992188, 1.715157),
                vec3(1519.096069, 6632.755859, 1.715157),
                vec3(1522.119019, 6632.522949, 1.715157),
                vec3(1523.367676, 6637.177734, 1.715157),
                vec3(1525.262085, 6639.978027, 1.715157),
                vec3(1532.777832, 6645.881348, 1.715157),
                vec3(1541.732910, 6654.021484, 1.715157),
                vec3(1549.637939, 6661.040527, 1.715157),
                vec3(1561.273315, 6667.175781, 1.715157),
                vec3(1578.669678, 6673.277832, 1.715157),
                
            },
            debug = false,
            onEnter = function()
                if exports.ox_inventory:Search('count', ConfigMetalDetector.ItemName) > 0 then -- IF U DONT HAVE OX INVENTORY COMMENT THIS 
                    ConfigMetalDetector.Notify('Metal Detector',"You have entered a search zone, use your metal detector!",4000,'bottom')
                end

                attualezona = "zona_1"
            end,
            onExit = function()
                attualezona = nil                
            end, 
            thickness = 3,
        }),

        -- [[ LOGICA PROBABILITÀ ]]
        -- Lo script estrae un numero da 1 a 100. 
        -- Esempio: [30] significa "da 1 a 30", [60] significa "da 31 a 60", e così via.
        -- ! L'ultimo indice deve essere sempre [100].        
        ricompense = {
            [30] = {
                prop = "prop_bottle_cap_01",
                item = "gold",
            },
            [60] = {
                prop = "v_res_tt_lighter",
                item = "accendino",
            },
            [80] = {
                prop = "prop_cigar_pack_01",
                item = "pacchetto_sigarette",
            },
            [90] = {
                prop = "p_watch_03_s",
                item = "goldwatch",
            },
            [100] = {
                prop = "w_ex_grenadesmoke",
                item = "weapon_bzgas",
            },
        }
    },

    ["zona_2"] = {
        centro_blip = vector3(-965.42, 5545.49, 13.85),
        poly = lib.zones.poly({
            points = {
                vec3(-882.660645, 5551.929199, 6.0),
                vec3(-899.772156, 5589.188477, 6.0),
                vec3(-917.642456, 5631.812012, 6.0),
                vec3(-930.541504, 5640.922852, 6.0),
                vec3(-949.097534, 5617.962891, 6.0),
                vec3(-958.958130, 5600.693848, 6.0),
                vec3(-967.925842, 5591.312012, 6.0),
                vec3(-982.550354, 5575.997070, 6.0),
                vec3(-1003.443420, 5557.101562, 6.0),
                vec3(-1024.936768, 5540.495117, 6.0),
                vec3(-1039.546875, 5533.271484, 6.0),
                vec3(-1063.752808, 5515.060059, 6.0),
                vec3(-1033.992188, 5497.198242, 6.0),
                vec3(-1012.716187, 5488.986328, 6.0),
                vec3(-997.131714, 5490.174316, 6.0),
                vec3(-968.786499, 5511.423828, 6.0),
                vec3(-960.044861, 5523.148438, 6.0),
                vec3(-942.695496, 5519.577637, 6.0),
                vec3(-922.064026, 5515.389648, 6.0),
            },
            debug = false,
            onEnter = function()
                if exports.ox_inventory:Search('count', ConfigMetalDetector.ItemName) > 0 then -- IF U DONT HAVE OX INVENTORY COMMENT THIS 
                    ConfigMetalDetector.Notify('Metal Detector',"You have entered a search zone, use your metal detector!",4000,'bottom')
                end

                attualezona = "zona_2"
            end,
            onExit = function()
                attualezona = nil                
            end, 
            thickness = 16,
        }),

        -- [[ LOGICA PROBABILITÀ ]]
        -- Lo script estrae un numero da 1 a 100. 
        -- Esempio: [30] significa "da 1 a 30", [60] significa "da 31 a 60", e così via.
        -- ! L'ultimo indice deve essere sempre [100].
        ricompense = {
            [30] = {
                prop = "prop_bottle_cap_01",
                item = "gold",
            },
            [60] = {
                prop = "v_res_tt_lighter",
                item = "accendino",
            },
            [80] = {
                prop = "prop_cigar_pack_01",
                item = "pacchetto_sigarette",
            },
            [90] = {
                prop = "p_watch_03_s",
                item = "goldwatch",
            },
            [100] = {
                prop = "w_ex_grenadesmoke",
                item = "weapon_bzgas",
            },
        }
    },
}

ConfigMetalDetector.BlipVenditaCoord = vector3(-930.4590, 5541.7314, 6.9475)
ConfigMetalDetector.PedModel = `ig_omega`
ConfigMetalDetector.PedHeading = 301.0204 

ConfigMetalDetector.VenditaItem = {
    {label = "Accendino", name = "accendino", price = 200},
    {label = "Oro", name = "gold", price = 1000},
    {label = "Pacchetto Di Sigarette", name = "pacchetto_sigarette", price = 300},
    {label = "Orologio D'Oro", name = "goldwatch", price = 1000},
    {label = "Granata A Gas", name = "weapon_bzgas", price = 2000},
    {label = "Portafoglio", name = "wallet", price = 300},
    {label = "Radio", name = "radio", price = 500},
    {label = "Anello di diamante", name = "diamond_ring", price = 1000},
    {label = "Collana d'oro", name = "goldchain", price = 1000},
    {label = "Anello d'oro", name = "goldring", price = 1000},
    {label = "Canna", name = "joint", price = 800},
}


-- DONT TOUCH BELOW THIS LINE
-- Used for language selection
function _L(str)
    return ConfigMetalDetector.Languages[ConfigMetalDetector.Locale][str] or str

end
