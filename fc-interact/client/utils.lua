RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function isPlayerInJob(job)
    local playerJob = ESX.PlayerData.job
    if type(job) == 'string' then
        if playerJob.name == job then
            return true
        end
    elseif type(job) == 'table' then
        local table = tableType(job)
        if table == 'object' then
            if job[playerJob.name] and tonumber(playerJob.grade) >= job[playerJob.name] then
                return true
            end
        elseif table == 'array' then
            for i = 1, #job, 1 do
                if job[i] == playerJob.name then
                    return true
                end
            end
        end
    end

    return false
end

function tableType(table)
    for k, v in pairs(table) do
        if type(k) == 'string' then
            return 'object'
        elseif type(k) == 'number' then
            return 'array'
        end
    end
end