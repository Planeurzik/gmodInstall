const fs = require('fs');

var downloadFilePath = __dirname+'/lua/autorun/server/download.lua';

var gamemodeId = '';

var mapId = '';

if (fs.existsSync(downloadFilePath)) { fs.unlinkSync(downloadFilePath); }

fs.readdirSync(__dirname+'/addons').forEach((addon) => {
    if (addon[0] !== '.') {
        var addonSplit = addon.split('_');
        var workshopId = addonSplit[addonSplit.length - 1];
        if (/^\d+$/.test(workshopId)) {
            fs.appendFileSync(downloadFilePath, 'resource.AddWorkshop( + workshopId + )\n');
        }
    }
});

if (gamemodeId !== '') fs.appendFileSync(downloadFilePath, 'resource.AddWorkshop( + gamemodeId + )\n');
if (mapId !== '') fs.appendFileSync(downloadFilePath, 'resource.AddWorkshop( + mapId + )\n');

console.log('All addons added !');
