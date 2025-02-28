local kills = 0
local deaths = 0
local assists = 0
local lastKilled = {} 
local isUIVisible = true 

function loadKDA()
    TriggerServerEvent('loadKDA')
end

function saveKDA()
    TriggerServerEvent('saveKDA', kills, deaths, assists)
end

function initUI()
    SendNUIMessage({
        type = 'updateKDA',
        kills = kills,
        deaths = deaths,
        assists = assists,
        visible = isUIVisible
    })
end

function toggleUI()
    isUIVisible = not isUIVisible
    SendNUIMessage({
        type = 'toggleUI',
        visible = isUIVisible
    })
end

AddEventHandler('entityDamaged', function(victim, culprit, weapon, baseDamage)
    if IsEntityAPed(victim) and IsEntityAPed(culprit) then
        local playerPed = PlayerPedId()
        if culprit == playerPed then
            if GetEntityHealth(victim) <= 0 then
                local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
                if not lastKilled[victimId] then
                    kills = kills + 1
                    lastKilled[victimId] = true
                    Citizen.SetTimeout(5000, function()
                        lastKilled[victimId] = nil
                    end)
                    SendNUIMessage({
                        type = 'updateKDA',
                        kills = kills,
                        deaths = deaths,
                        assists = assists,
                        visible = isUIVisible
                    })
                    saveKDA()
                end
            end
        elseif victim == playerPed then
            deaths = deaths + 1
            SendNUIMessage({
                type = 'updateKDA',
                kills = kills,
                deaths = deaths,
                assists = assists,
                visible = isUIVisible
            })
            saveKDA()
        end
    end
end)

AddEventHandler('playerAssist', function()
    assists = assists + 1
    SendNUIMessage({
        type = 'updateKDA',
        kills = kills,
        deaths = deaths,
        assists = assists,
        visible = isUIVisible
    })
    saveKDA()
end)

RegisterCommand('kda', function()
    toggleUI()
    TriggerEvent('chat:addMessage', {
        -- args = { 'KDA Sistemi', isUIVisible and 'Açık' or 'Kapalı' }
    })
end, false)

Citizen.CreateThread(function()
    loadKDA()
end)

RegisterNetEvent('updateKDA')
AddEventHandler('updateKDA', function(newKills, newDeaths, newAssists)
    kills = newKills
    deaths = newDeaths
    assists = newAssists
    initUI()
end)