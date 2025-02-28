RegisterNetEvent('loadKDA')
AddEventHandler('loadKDA', function()
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]


    MySQL.query('SELECT kills, deaths, assists FROM player_kda WHERE identifier = ?', { identifier }, function(result)
        if result and result[1] then

            TriggerClientEvent('updateKDA', src, result[1].kills, result[1].deaths, result[1].assists)
        else
            -- Oyuncu ilk defa geliyorsa, yeni bir kayıt oluştur
            MySQL.insert('INSERT INTO player_kda (identifier, kills, deaths, assists) VALUES (?, 0, 0, 0)', { identifier }, function()
                TriggerClientEvent('updateKDA', src, 0, 0, 0)
            end)
        end
    end)
end)

RegisterNetEvent('saveKDA')
AddEventHandler('saveKDA', function(kills, deaths, assists)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.update('UPDATE player_kda SET kills = ?, deaths = ?, assists = ? WHERE identifier = ?', { kills, deaths, assists, identifier }, function(rowsChanged)
        if rowsChanged > 0 then
            print("KDA verileri güncellendi.")
        end
    end)
end)

RegisterCommand('kda', function(source, args, rawCommand)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]

    MySQL.query('SELECT kills, deaths, assists FROM player_kda WHERE identifier = ?', { identifier }, function(result)
        if result and result[1] then
            TriggerClientEvent('chat:addMessage', src, {
                multiline = true,
                args = {"KDA Sistemi", string.format("Kills: %d, Deaths: %d, Assists: %d", result[1].kills, result[1].deaths, result[1].assists)}
            })
        else
            TriggerClientEvent('chat:addMessage', src, {
                multiline = true,
                args = {"KDA Sistemi", "KDA bilgileriniz bulunamadı. Lütfen bir süre bekleyin."}
            })
        end
    end)
end)

AddEventHandler('playerJoining', function()
    local src = source
    TriggerEvent('loadKDA', src)
end)