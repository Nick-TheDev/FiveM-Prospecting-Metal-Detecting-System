RegisterNetEvent('ricompensa:metaldetector')
AddEventHandler('ricompensa:metaldetector', function(itemName)
    -- exports.ox_inventory:AddItem(source, itemName, 1)

    print(("[METALDETECTOR] Player %s found %s"):format(source, itemName))
end)

RegisterNetEvent('metaldetector:vendiItem', function(itemName, prezzo, itemLabel)

    -- local itemCount = exports.ox_inventory:Search(source, "count", itemName)

    -- if itemCount > 0 then
    --     exports.ox_inventory:RemoveItem(source, itemName, 1)
    --     exports.ox_inventory:AddItem(source, ConfigMetalDetector.MoneyItemName, prezzo)

    --     TriggerClientEvent('metaldetector:Notify', src, _L('title'), _L('notify_sold'):format(itemLabel, prezzo), 4000, 'bottom')
    -- else
    --     TriggerClientEvent('metaldetector:Notify', src, _L('title'), _L('notify_no_item'), 4000, 'bottom')
    -- end

    print(("[METALDETECTOR] Player %s sold %s for $%s" ):format(source, itemLabel, prezzo))
end)


GlobalState.SNStrovata = false