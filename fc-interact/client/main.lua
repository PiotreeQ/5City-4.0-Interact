local SendNUIMessage = SendNUIMessage
local GetEntityCoords = GetEntityCoords

local visibleOptions = {}
local optionsFunctions = {}
local isVisible = false
local isDisabled = false
local optionsForId = {}
local interactOptions = {
    -- [1] = {
    --     coords = vector3(25.05, -1347.29, 29.5),
    --     distance = 1.75,
    --     options = {
    --         {
    --             name = 'CashRegister',
    --             label = 'Otwórz sklep',
    --             event = 'fc-interact:OpenShop',
    --             args = 'General',
    --             job = {['police'] = 3},
    --             canInteract = function()
    --                 return true
    --             end
    --         },
    --     }
    -- },
}

local function hideInteract(id)
    if visibleOptions[id] then
        SendNUIMessage({action = 'HideInteract', id = id})
        visibleOptions[id] = nil
    end
    optionsForId[id] = nil
end

function addInteract(data)
    if not data.options then
        return
    end

    if not data.coords and not data.entity then
        return
    end

    local interactId <const> = (#interactOptions + 1)
    interactOptions[interactId] = {
        coords = data.coords or nil,
        entity = data.entity or nil,
        distance = data.distance or 1.75,
        options = data.options
    }
    return interactId
end

exports('addInteract', addInteract)

function removeInteract(id)
    if not interactOptions[id] then
        print(('Attempt to remove not existing option %s'):format(id))
    end

    hideInteract(id)
    table.remove(interactOptions, id)
end

exports('removeInteract', removeInteract)

function disableInteract(bool)
    isDisabled = bool
end

exports('disableInteract', disableInteract)

RegisterCommand('interact_select', function()
    for id, type in pairs(visibleOptions) do
        if type == 'all' then
            SendNUIMessage({action = 'SelectInteract', id = id})
            break
        end
    end
end)

RegisterCommand('interact_use', function()
    for id, type in pairs(visibleOptions) do
        if type == 'all' then
            SendNUIMessage({action = 'UseInteract', id = id})
            break
        end
    end
end)

RegisterNUICallback('UseInteract', function(data)
    TriggerEvent(data.event, data.args)
end)

RegisterKeyMapping('interact_use', 'Zatwierdź opcje', 'keyboard', 'E')

RegisterKeyMapping('interact_select', 'Zmień opcje', 'keyboard', 'DOWN')

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        if not isDisabled then
            local plyCoords = GetEntityCoords(cache.ped)
            local screenX, screenY = GetActiveScreenResolution()
            for i = 1, #interactOptions, 1 do
                local item = interactOptions[i]
                if item.entity then
                    item.coords = DoesEntityExist(item.entity) and GetEntityCoords(item.entity) or nil
                end
    
                if item.coords then
                    local dist = #(plyCoords - item.coords)
                    if dist <= (item.distance * 2.5) then
                        sleep = 1000
                    elseif dist <= (item.distance * 1.5) then
                        sleep = 500
                    end
        
                    if dist <= item.distance and not IsPauseMenuActive() then
                        local state = visibleOptions[i]
                        local onscreen, x, y = GetScreenCoordFromWorldCoord(item.coords.x, item.coords.y, item.coords.z)
                        if onscreen and x and y then
                            sleep = 10
                            local posX = (x * screenX)
                            local posY = (y * screenY)

                            local sortedItems = {}
                            if optionsForId[i] then
                                sortedItems = optionsForId[i]
                            else
                                for i = 1, #item.options, 1 do
                                    local option = item.options[i]
                                    if option.canInteract and option.canInteract() then
                                        if option.job and isPlayerInJob(option.job) then
                                            sortedItems[i] = option
                                            sortedItems[i].canInteract = nil
                                        elseif not option.job then
                                            sortedItems[i] = option
                                            sortedItems[i].canInteract = nil
                                        end
                                    elseif not option.canInteract then
                                        if option.job and isPlayerInJob(option.job) then
                                            sortedItems[i] = option
                                            sortedItems[i].canInteract = nil
                                        elseif not option.job then
                                            sortedItems[i] = option
                                            sortedItems[i].canInteract = nil
                                        end
                                    end
                                end
                                optionsForId[i] = sortedItems
                            end
                            if #sortedItems > 0 then
                                if dist <= 0.9 then
                                    if (not state or state == 'circle') then
                                        visibleOptions[i] = 'all'
                                        SendNUIMessage({
                                            action = 'ShowInteract', type = 'all', id = i, options = sortedItems,
                                            position = {
                                                left = posX,
                                                top = posY,
                                                scale = scale
                                            }
                                        })
                                    else
                                        SendNUIMessage({
                                            action = 'UpdateInteract',
                                            id = i,
                                            left = posX,
                                            top = posY,
                                            scale = scale
                                        })
                                    end
                                elseif dist > 0.9 then
                                    if (not state or state == 'all') then
                                        visibleOptions[i] = 'circle'
                                        SendNUIMessage({
                                            action = 'ShowInteract', type = 'circle', id = i,
                                            icon = item.icon,
                                            position = {
                                                left = posX,
                                                top = posY,
                                                scale = scale
                                            }
                                        })
                                    else
                                        SendNUIMessage({
                                            action = 'UpdateInteract',
                                            id = i,
                                            left = posX,
                                            top = posY,
                                            scale = scale
                                        })
                                    end
                                end
                            else
                                hideInteract(i)
                            end
                        else
                            hideInteract(i)
                        end
                    else
                        hideInteract(i)
                    end
                end
            end
        else
            for k, v in pairs(visibleOptions) do
                hideInteract(k)
            end
        end
        Wait(sleep)
    end
end)
