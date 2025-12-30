local metaldetector_using = false
attualezona = nil
local status_ricerca = nil
local coordinate_ricompensa = nil 
local coordinate_prec = nil
local attachedEntities = {}
local npcVendita = nil

function ScenaCustom(coords, rotation, peds, props, durata, camData)
    local scene = NetworkCreateSynchronisedScene(
        coords.x, coords.y, coords.z,
        rotation.x, rotation.y, rotation.z,
        2, true, false, 1.0, 0.0, 1.0
    )

    -- CAMERA
    local cam
    if camData then
        RequestAnimDict(camData.dict)
        while not HasAnimDictLoaded(camData.dict) do Wait(0) end

        cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
        PlayCamAnim(cam, camData.nome, camData.dict, coords, rotation, false, 2)
        RenderScriptCams(true, false, 0, true, true)
    end

    -- PED
    for _, data in ipairs(peds) do
        RequestAnimDict(data.anim.dict)
        while not HasAnimDictLoaded(data.anim.dict) do Wait(0) end

        NetworkAddPedToSynchronisedScene(
            data.ped,
            scene,
            data.anim.dict,
            data.anim.anim,
            8.0, -8.0, 0, 0, 1148846080, 0
        )
    end

    -- PROPS
    local spawnedProps = {}

    for _, p in ipairs(props) do
        RequestModel(p.model)
        while not HasModelLoaded(p.model) do Wait(0) end

        local obj = CreateObject(p.model, coords.x, coords.y, coords.z, true, true, false)
        SetEntityCollision(obj, false, true)

        RequestAnimDict(p.anim.dict)
        while not HasAnimDictLoaded(p.anim.dict) do Wait(0) end

        NetworkAddEntityToSynchronisedScene(
            obj,
            scene,
            p.anim.dict,
            p.anim.anim,
            8.0, -8.0, 0
        )

        table.insert(spawnedProps, {
            entity = obj,
            deleteAfter = p.cancella_prop
        })
    end

    NetworkStartSynchronisedScene(scene)

    -- CLEANUP PROPS
    for _, p in ipairs(spawnedProps) do
        if p.deleteAfter then
            CreateThread(function()
                Wait(p.deleteAfter)
                if DoesEntityExist(p.entity) then
                    DeleteEntity(p.entity)
                end
            end)
        end
    end

    -- FINE SCENA
    Wait(durata)

    if cam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam)
    end
end

CreateThread(function()
    for k, v in pairs(ConfigMetalDetector.Zone) do
        if type(v.centro_blip) == "vector3" then 
            AddTextEntry("PROSP_BLIP", "Zona di ricerca")
            blip = AddBlipForCoord(v.centro_blip)
            SetBlipSprite(blip, 485)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("PROSP_BLIP")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterCommand("metal", function ()
    if metaldetector_using then
        metaldetector_using = false
        StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
        CleanupModels()
    else
        local ped_coord = GetEntityCoords(cache.ped)
        local check = false
        for k, v in pairs(ConfigMetalDetector.Zone) do
            if v.poly:contains(ped_coord) then


                check = true
            end
        end

        if check == true then
            metaldetector_using = true
            AttachEntity(cache.ped, "w_am_metaldetector")
            if not IsEntityPlayingAnim(cache.ped, "mini@golfai", "wood_idle_a", 3) then
                PlayAnimUpper(cache.ped, "mini@golfai", "wood_idle_a")
            end

            Citizen.CreateThread(function()
                while metaldetector_using do             
                    if not IsEntityPlayingAnim(cache.ped, "mini@golfai", "wood_idle_a", 3) then
                        PlayAnimUpper(cache.ped, "mini@golfai", "wood_idle_a")
                    end

                    if IsControlJustPressed(0, 73)  then 
                        ClearPedTasks(cache.ped)
                        metaldetector_using = false
                        StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
                        CleanupModels()
                    end
                    
                    Citizen.Wait(0)
                end
            end)
        else
            ConfigMetalDetector.Notify(_L('title'), _L('only_in_zone'), 4000, 'bottom')
        end
    end
end, false)

exports('UsaMetalDetector', function(data, slot)
    if metaldetector_using then
        metaldetector_using = false
        StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
        CleanupModels()
    else
        local ped_coord = GetEntityCoords(cache.ped)
        local check = false
        for k, v in pairs(ConfigMetalDetector.Zone) do
            if v.poly:contains(ped_coord) then


                check = true
            end
        end

        if check == true then
            metaldetector_using = true
            AttachEntity(cache.ped, "w_am_metaldetector")
            if not IsEntityPlayingAnim(cache.ped, "mini@golfai", "wood_idle_a", 3) then
                PlayAnimUpper(cache.ped, "mini@golfai", "wood_idle_a")
            end

            Citizen.CreateThread(function()
                while metaldetector_using do             
                    if not IsEntityPlayingAnim(cache.ped, "mini@golfai", "wood_idle_a", 3) then
                        PlayAnimUpper(cache.ped, "mini@golfai", "wood_idle_a")
                    end

                    if IsControlJustPressed(0, 73)  then 
                        ClearPedTasks(cache.ped)
                        metaldetector_using = false
                        StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
                        CleanupModels()
                    end
                    
                    Citizen.Wait(0)
                end
            end)
        else
            ConfigMetalDetector.Notify(_L('title'), _L('only_in_zone'), 4000, 'bottom')
        end
    end
end)

RegisterNetEvent('metalDetector:Rimosso')
AddEventHandler('metalDetector:Rimosso', function()
    if metaldetector_using then
        metaldetector_using = false
        StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
        CleanupModels()
    end
end)

function trovaIntervallo(tabella, a)
    local intervallo = nil
    local chiavi = {}

    -- Estrai le chiavi dalla tabella e ordinale
    for chiave in pairs(tabella) do
        table.insert(chiavi, chiave)
    end
    table.sort(chiavi)

    if a < chiavi[1] then
        intervallo = chiavi[1]
    elseif a >= chiavi[#chiavi] then
        intervallo = chiavi[#chiavi]
    else
        for i = 1, #chiavi - 1 do
            if a >= chiavi[i] and a < chiavi[i + 1] then
                intervallo = chiavi[i + 1]
                break
            end
        end
    end

    return intervallo
end

Citizen.CreateThread(function()
    local notifica_mostata = false
    while true do 
        TempoThread = 500
        if attualezona ~= nil and metaldetector_using == true then 

            if IsPedRunning(cache.ped) then 
                ConfigMetalDetector.Notify(_L('title'), _L('dont_run'), 3000, 'bottom')
                Citizen.Wait(1000)
            end

            if status_ricerca == nil then 
                status_ricerca = math.random(15,20)
                notifica_mostata = false
            else
                local coord_ped = GetEntityCoords(cache.ped)
                if status_ricerca > 0 and IsPedOnFoot(cache.ped) and IsPedWalking(cache.ped) and (coordinate_prec == nil or #(coordinate_prec - coord_ped) > 1.0) then 
                    local timer_suono = nil
                    coordinate_prec = coord_ped

                    if status_ricerca < 2.0 then
                        timer_suono = 0.20
                    elseif status_ricerca < 4.0 then
                        timer_suono = 0.30
                    elseif status_ricerca < 6.0 then
                        timer_suono = 0.4
                    elseif status_ricerca < 7.0 then
                        timer_suono = 0.425
                    elseif status_ricerca < 10.0 then
                        timer_suono = 0.45
                    elseif status_ricerca < 11.0 then
                        timer_suono = 0.5
                    elseif status_ricerca < 12.0 then
                        timer_suono = 0.75
                    elseif status_ricerca < 13.0 then
                        timer_suono = 1.0
                    elseif status_ricerca < 14.0 then
                        timer_suono = 1.25
                    end

                    status_ricerca = status_ricerca - 0.5

                    if timer_suono then
                        GestisciSound(timer_suono * 1000)
                    end

                    if status_ricerca == 0 then
                        coordinate_ricompensa = coord_ped
                    end
                end

                if coordinate_ricompensa ~= nil then 
                    local dist = #(coord_ped - coordinate_ricompensa)

                    if dist < 2.0 then
                        timer = 0.20
                    elseif dist < 4.0 then
                        timer = 0.30
                    elseif dist < 5.0 then
                        timer = 0.4
                    elseif dist < 6.5 then
                        timer = 0.425
                    elseif dist < 7.5 then
                        timer = 0.45
                    elseif dist < 10.0 then
                        timer = 0.5
                    elseif dist < 12.5 then
                        timer = 0.75
                    elseif dist < 15.0 then
                        timer = 1.0
                    elseif dist < 20.0 then
                        timer = 1.25
                    elseif dist < 25.0 then
                        timer = 1.5
                    elseif dist < 30.0 then
                        timer = 2.0
                    end

                    if dist < 30.0 and (IsPedOnFoot(cache.ped) and (IsPedWalking(cache.ped) or IsPedStill(cache.ped))) then
                        GestisciSound(timer * 1000)
                    else
                        coordinate_ricompensa = nil
                        status_ricerca = nil
                        GestisciSound(nil, true) --brekka il sound
                    end

                    if dist <= 2.0 then 
                        TempoThread = 0
                        if not notifica_mostata then
                            ConfigMetalDetector.Notify(_L('title'), _L('item_found'), 5000, 'bottom')
                            notifica_mostata = true
                        end
                        DrawMarker(20, coordinate_ricompensa.x, coordinate_ricompensa.y, coordinate_ricompensa.z - 0.5, 0, 0, 0, 0, 180.0, 0, 0.2, 0.2, 0.2, 255, 208, 0, 255, true, true)

                        if IsControlJustPressed(0, 38) then
                            coordinate_ricompensa = nil
                            status_ricerca = nil
                            notifica_mostata = false
                            GestisciSound(nil, true)
                            math.randomseed(GetGameTimer())
                            local casuale = math.random(1, 100)
                            local ricompensa_item, ricompensa_prop = nil, nil

                            local intervallo = trovaIntervallo(ConfigMetalDetector.Zone[tostring(attualezona)].ricompense, casuale)
                            ricompensa_item, ricompensa_prop = ConfigMetalDetector.Zone[tostring(attualezona)].ricompense[intervallo].item, ConfigMetalDetector.Zone[tostring(attualezona)].ricompense[intervallo].prop

                            if ricompensa_item == "weapon_snspistol" and GlobalState.SNStrovata == true then 
                                while ricompensa_item == "weapon_snspistol" do 
                                    casuale = math.random(1, 100)
                                    intervallo = trovaIntervallo(ConfigMetalDetector.Zone[tostring(attualezona)].ricompense, casuale)
                                    ricompensa_item, ricompensa_prop = ConfigMetalDetector.Zone[tostring(attualezona)].ricompense[intervallo].item, ConfigMetalDetector.Zone[tostring(attualezona)].ricompense[intervallo].prop
                                    Citizen.Wait(1000)
                                end    
                            end
                        
                            DigSequence(ricompensa_prop)
                            TriggerServerEvent('ricompensa:metaldetector', ricompensa_item)
                        end
                    end
                end
            end
        else
            GestisciSound(nil, true) --brekka il sound
            if metaldetector_using then
                metaldetector_using = false
                StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
                CleanupModels()
                ConfigMetalDetector.Notify(_L('title'), _L('notify_exit'), 4000, 'bottom')
                notifica_mostata = false
            end
        end

        Citizen.Wait(TempoThread)
   end
end)

local gestendo_sound = false
local lastimer = 0 
function GestisciSound(timer, breaksound)
    if breaksound == true then 
        gestendo_sound = false 
        lastimer = 0
        return
    end

    if not gestendo_sound then 
        gestendo_sound = true 
        lastimer = timer
        Citizen.CreateThread(function()
            while gestendo_sound do 
                PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0) 
                Citizen.Wait(timer)
            end
        end)
    elseif lastimer ~= timer then 
        gestendo_sound = false 
        Citizen.Wait(lastimer)
        GestisciSound(timer)
    end
end

local entityOffsets = {
    ["w_am_digiscanner"] = {
        bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),
    },
    ["w_am_metaldetector"] = {
        bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),
    },
}


local scannerEntity = nil
function AttachEntity(ped, model)
    if entityOffsets[model] then
        EnsureModel(model)
        local pos = GetEntityCoords(cache.ped)
        local ent = CreateObject(model, pos, 1, 1, 0)
        AttachEntityToEntity(ent, ped, GetPedBoneIndex(ped, entityOffsets[model].bone), entityOffsets[model].offset, entityOffsets[model].rotation, 1, 1, 0, 0, 2, 1)
        scannerEntity = ent
        table.insert(attachedEntities, ent)
    end
end

function CleanupModels()
    for _, ent in next, attachedEntities do
        DetachEntity(ent, 0, 0)
        DeleteEntity(ent)
    end
    attachedEntities = {}
    scannerEntity = nil
end


function DigSequence(propitem)    
    StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
    CleanupModels()
    metaldetector_using = false

    local ped = cache.ped
    local pedCoords = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    pedCoords = vector3(pedCoords.x, pedCoords.y, pedCoords.z - 1.0) 

    local cam = {
        dict = "anim@scripted@player@mission@tun_iaa_dig@male@",
        nome = "action_cam"
    }
     
    local ped = {

        {
            ped = ped,
            anim = {
                dict = "anim@scripted@player@mission@tun_iaa_dig@male@",
                anim = "action"
            },
        }
    }

    local prop = {
        {
            model = `h4_prop_h4_box_ammo_01a`,
            cancella_prop = 57600,

            anim = {
                dict = "anim@scripted@player@mission@tun_iaa_dig@male@",
                anim = "action_ammo_box"
            }
        },
        {
            model = propitem,
            cancella_prop = 7600,
            anim = {
                dict = "anim@scripted@player@mission@tun_iaa_dig@male@",
                anim = "action_file"
            }
        },
        {
            model = `tr_prop_tr_sand_01b`,
            cancella_prop = 47600,
            anim = {
                dict = "anim@scripted@player@mission@tun_iaa_dig@male@",
                anim = "action_sand_dug"
            }
        },
        {
            model = `tr_prop_tr_sand_01a`,
            cancella_prop = 47600,
            anim = {
                dict = "anim@scripted@player@mission@tun_iaa_dig@male@",
                anim = "action_sand_pile"
            }
        }
    }

    ScenaCustom(pedCoords, pedRotation, ped, prop, 8000, cam)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if metaldetector_using then
            metaldetector_using = false
            StopEntityAnim(cache.ped, "wood_idle_a", "mini@golfai", true)
            CleanupModels()
        end
    end
end)

function EnsureAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function EnsureModel(model)
    if not IsModelInCdimage(model) then
    else
        if not HasModelLoaded(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
        end
    end
end

local previousAnim = nil
function StopAnim(ped)
    if previousAnim then
        StopEntityAnim(ped, previousAnim[2], previousAnim[1], true)
        previousAnim = nil
    end
end

function PlayAnimFlags(ped, dict, anim, flags)
    StopAnim(ped)
    EnsureAnimDict(dict)
    local len = GetAnimDuration(dict, anim)
    TaskPlayAnim(ped, dict, anim, 1.0, -1.0, len, flags, 1, 0, 0, 0)
    previousAnim = {dict, anim}
end

function PlayAnimUpper(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 49)
end
function PlayAnim(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 0)
end

-- [[ PED VENDITA ]]

function ApriMenuVendita()
    local elements = {}

    for _, item in ipairs(ConfigMetalDetector.VenditaItem) do
        table.insert(elements, {
            title = item.label .. " - $" .. item.price,
            description = "Vendi questo item",
            onSelect = function ()
                TriggerServerEvent('metaldetector:vendiItem', item.name ,item.price ,item.label)
            end,
            args = {name = item.name, price = item.price}
        })
    end

    lib.registerContext({
        id = 'menu_vendita_metaldetector',
        title = _L('pawnshop_title'),
        options = elements
    })

    lib.showContext('menu_vendita_metaldetector')
end

CreateThread(function()
    -- Caricamento modello PED
    local model = ConfigMetalDetector.PedModel
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    -- Creazione PED
    npcVendita = CreatePed(4, model, ConfigMetalDetector.BlipVenditaCoord.x, ConfigMetalDetector.BlipVenditaCoord.y, ConfigMetalDetector.BlipVenditaCoord.z - 1.0, ConfigMetalDetector.PedHeading, false, true)
    
    SetEntityAsMissionEntity(npcVendita, true, true)
    SetBlockingOfNonTemporaryEvents(npcVendita, true)
    SetEntityInvincible(npcVendita, true)
    FreezeEntityPosition(npcVendita, true)

    if ConfigMetalDetector.UseTarget then
        exports.ox_target:addLocalEntity(npcVendita, {
            {
                name = 'vendita_metaldetector',
                icon = 'fa-solid fa-hand-holding-dollar',
                label = _L('open_catalog'),
                onSelect = function()
                    ApriMenuVendita()
                end
            }
        })
    else
        local isTextUiOpen = false -- Variabile di controllo per evitare chiamate infinite

        while true do
            local sleep = 1500
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - ConfigMetalDetector.BlipVenditaCoord)

            if dist < 10.0 then
                sleep = 0
                DrawMarker(2, ConfigMetalDetector.BlipVenditaCoord.x, ConfigMetalDetector.BlipVenditaCoord.y, ConfigMetalDetector.BlipVenditaCoord.z + 1.2, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 150, false, true, 2, nil, nil, false)
                
                if dist < 2.0 then
                    if not isTextUiOpen then
                        lib.showTextUI("[E] - " .. _L('open_catalog'))
                        isTextUiOpen = true
                    end
                    
                    if IsControlJustReleased(0, 38) then -- Tasto E
                        ApriMenuVendita()
                    end
                else
                    if isTextUiOpen then
                        lib.hideTextUI()
                        isTextUiOpen = false
                    end
                end
            elseif isTextUiOpen then
                -- Sicurezza: se il giocatore si allontana velocemente (es. teleport o corsa)
                lib.hideTextUI()
                isTextUiOpen = false
            end
            Wait(sleep)
        end
    end
end)

-- Pulizia allo stop della risorsa
AddEventHandler('onResourceStop', function(resourceName)
    if (resourceName == GetCurrentResourceName()) then
        if npcVendita then
            DeleteEntity(npcVendita)
        end
    end
end)

RegisterNetEvent('metalDetector:Notify', function(title, message, duration, position)
    ConfigMetalDetector.Notify(title, message, duration, position)
end)