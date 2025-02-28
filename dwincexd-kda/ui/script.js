let kills = 0;
let deaths = 0;
let assists = 0;

function updateKDA(newKills, newDeaths, newAssists) {
    kills = newKills;
    deaths = newDeaths;
    assists = newAssists;
    document.getElementById('kills').innerText = `Kills: ${kills}`;
    document.getElementById('deaths').innerText = `Deaths: ${deaths}`;
    document.getElementById('kda').innerText = `KDA: ${calculateKDA()}`;
}

function calculateKDA() {
    return ((kills + assists) / Math.max(1, deaths)).toFixed(2);
}

function toggleUIVisibility(visible) {
    document.getElementById('kda-container').style.display = visible ? 'flex' : 'none';
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'updateKDA') {
        updateKDA(event.data.kills, event.data.deaths, event.data.assists);
    } else if (event.data.type === 'toggleUI') {
        toggleUIVisibility(event.data.visible);
    }
});